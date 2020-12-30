function initialize {
    gcloud auth activate-service-account --key-file $GCS_KEYFILE
}

function upload {
    echo "uploading $GCS_BUCKET/$1 " >&2
    gsutil cp - $GCS_BUCKET/$1
}

function list_backups {
    gsutil ls $GCS_BUCKET | grep "/$" | grep pg-logical- | cut -d'/' -f4
}

function delete_backup {
    gsutil rm -r $GCS_BUCKET/pg-logical-$1
}
