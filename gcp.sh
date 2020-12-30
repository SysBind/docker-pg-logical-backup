function initialize {
    gcloud auth activate-service-account --key-file $GCS_KEYFILE
}

function upload {
    echo "uploading $GCS_BUCKET/$1 " >&2
    gsutil cp - $GCS_BUCKET/$1
}

function backup_number {
    local number=0
    for line in `gsutil ls $GCS_BUCKET | grep "/$" | grep pg-logical-`; do
	echo -n "prev backup folder: $line..." >&2
	number=$((number+1))
    done
    echo -n $number
}
