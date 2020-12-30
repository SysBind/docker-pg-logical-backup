
function initialize {
    cat <<EOF > /root/.s3cfg
# Setup endpoint
host_base = $S3_ENDPOINT
host_bucket = $S3_ENDPOINT
bucket_location = us-east-1
use_https = $S3_USE_HTTPS

# Setup access keys
access_key =  $S3_ACCESS_KEY
secret_key = $S3_SECRET_KEY

# Enable S3 v4 signature APIs
signature_v2 = False
EOF
}


function upload {
    echo "uploading $1 " >&2

    s3cmd put - s3://$S3_BUCKET/$1
}

# list_backups
function list_backups {
    s3cmd ls s3://$S3_BUCKET/ | cut -d'/' -f4
}

function delete_backup {
    for dump in `s3cmd ls  s3://$S3_BUCKET/pg-logical-$1/ | cut -d'/' -f5`; do
        s3cmd del s3://$S3_BUCKET/pg-logical-$1/$dump;
    done
    s3cmd del s3://$S3_BUCKET/pg-logical-$1
}
