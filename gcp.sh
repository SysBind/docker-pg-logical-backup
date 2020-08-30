

function authenticate {
    gcloud auth activate-service-account --key-file $GCS_KEYFILE
}

function upload {
    gsutil cp - $GCS_BUCKET/$1.sql.gz
}

function backup_number {
    local number=0
    for line in `gsutil ls $GCS_BUCKET | grep "/$" | grep pg-logical-`; do
	echo -n "prev backup folder: $line..." >&2
	number=$((number+1))
    done
    echo -n $number
}
