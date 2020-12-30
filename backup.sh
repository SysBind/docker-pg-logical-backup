#! /usr/bin/env bash

DAYS_KEEP=${DAYS_KEEP:-30}

# source the appropriate cloud interface
# (defines: init(), upload(), list_backups(), [get_dump()], delete_backup())
if [[ ! -z "${S3_BUCKET}" ]]; then
  source s3.sh
elif [[ ! -z "${GCS_BUCKET}" ]]; then
  source gcp.sh
else
  source azure.sh
fi

source envoy.sh # istio support

# enable unofficial bash strict mode
set -o errexit
set -o nounset
set -o pipefail

PG_BIN=$PG_DIR/$PG_VERSION/bin
ERRORCOUNT=0

function filter_dbs {
    grep -v -w postgres | grep -v -w template0 | grep -v -w template1
}

function list_dbs {
    "$PG_BIN"/psql --tuples-only -c "\l" | cut -f1 -d"|" | filter_dbs
}

function dump {
    # settings are taken from the environment (user, password,..)
    "$PG_BIN"/pg_dump --create $db
}

function compress {
    pigz
}

set +o nounset
if [[ ! -z "${ENVOY_SUPPORT}" ]]; then
    wait_for_proxy
fi
set -o nounset

echo "$0: Calling init" >&2

initialize
BACKUPNUMBER=`date +%Y%m%d%H%M`

# Perform backup for each database
for db in `list_dbs`; do
    set -x
    dump $db | compress | upload  pg-logical-$BACKUPNUMBER/$db.sql.gz
    [[ ${PIPESTATUS[0]} != 0 || ${PIPESTATUS[1]} != 0 || ${PIPESTATUS[2]} != 0 ]] && (( ERRORCOUNT += 1 ))
    set +x
done


# Delete old backups
DELETE_BEFORE=`date +%Y%m%d%H%M -d "$DAYS_KEEP day ago"`
for backup in `list_backups`; do
    backup_number=`echo $backup | cut -d'-' -f3`
    if [ $DELETE_BEFORE -gt $backup_number ]; then
        echo "deleting $backup_number"
        delete_backup $backup_number
    fi
done

# Signal envoy to shutdown (if so configured).
set +o nounset
if [[ ! -z "${ENVOY_SUPPORT}" ]]; then
    terminate_proxy
fi

exit $ERRORCOUNT
