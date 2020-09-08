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

function decompress {
    pigz -dc
}

echo "$0: Sleeping for 30 seconds..." >&2
sleep 30s
echo "$0: Calling authenticate" >&2

authenticate

echo "fetching last backup"
BACKUPNUMBER=`backup_number`

for dump in `list_dumps $BACKUPNUMBER`; do
    set -x
    get_dump $dump | decompress | psql
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
