#! /usr/bin/env bash

# source the appropriate cloud interface
# (defines: authenticate(), upload(), backup_number() )
if [[ ! -z "${GCS_BUCKET}" ]]; then
  source gcp.sh
else
  source azure.sh
fi

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
    "$PG_BIN"/pg_dump --no-owner --create $db
}

function compress {
    pigz
}

echo "$0: Sleeping for 30 seconds..." >&2
sleep 30s
echo "$0: Calling authenticate" >&2

authenticate
BACKUPNUMBER=`backup_number`

for db in `list_dbs`; do
    set -x
    dump $db | compress | upload  pg-logical-$BACKUPNUMBER/$db.sql.gz
    [[ ${PIPESTATUS[0]} != 0 || ${PIPESTATUS[1]} != 0 || ${PIPESTATUS[2]} != 0 ]] && (( ERRORCOUNT += 1 ))
    set +x
done

set +o nounset
if [[ ! -z "${ENVOY_SIGNAL_SHUTDOWN}" ]]; then
    echo "Telling envoy to exit gracefully.."
    curl -X POST http://127.0.0.1:15000/drain_listeners?graceful
    sleep 1s; echo -n ".."
    curl -X POST http://127.0.0.1:15000/healthcheck/fail
    sleep 1s; echo -n ".."
    curl -X POST http://127.0.0.1:15000/quitquitquit
fi

exit $ERRORCOUNT
