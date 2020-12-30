
function initialize {
    echo <<EOF > /root/.s3cfg
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
    s3cmd mb s3://$S3_BUCKET
}


function upload {
    echo "uploading $1 " >&2
    
}
