#! /usr/bin/env bash

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
    psql --tuples-only -c "\l" | cut -f1 -d"|" | filter_dbs
}

function dump {
    # settings are taken from the environment
    "$PG_BIN"/pg_dump $db
}

function compress {
    pigz
}

function gcs_upload {
    gsutil cp - $GCS_BUCKET/$1
}

function backup_number {
    local number=0
    for line in `gsutil ls gs://$GCS_BUCKET | grep "/$" | grep pg-logical-`; do
	echo "prev backup folder: $line" >&2
    done
    echo -n $number
}

gcloud auth activate-service-account --key-file $GCS_KEYFILE
BACKUPNUMBER=`backup_number`

for db in `list_dbs`; do
    set -x
    dump $db | compress | gcs_upload  pg-logical-$BACKUPNUMBER/$db
    [[ ${PIPESTATUS[0]} != 0 || ${PIPESTATUS[1]} != 0 || ${PIPESTATUS[2]} != 0 ]] && (( ERRORCOUNT += 1 ))
    set +x
done

exit $ERRORCOUNT
