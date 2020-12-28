# Generic PostgreSQL Backup/Restore Docker image
Image to execute logical backup per postgresql database and upload to buckets (or save to volume),
And also to execute restore job to other target on-demand

## Env Vars
DAYS_KEEP - Default to 7, delete backups older than this value in days.

### PostgreSQL
PG_VERSION - 9.5, 9.6, 10, 11 or 12

PGHOST, PGUSER, etc, See: https://www.postgresql.org/docs/12/libpq-envars.html


### Google Cloud
GCS_BUCKET - gs://BUCKET_NAME
GCS_KEYFILE - Path to Google Service Account Credentials, Should be injected into the container as a volume.



### Azure
AZURE_CONTAINER_NAME
AZURE_STORAGE_ACCOUNT
AZURE_STORAGE_KEY


### S3
S3_BUCKET
S3_ACCESS_KEY
S3_SECRET_KEY

### Restoring Backup

RESTORE_DB - Database name to restore 
              (Which is also the filename of the dump)

### Istio
ENVOY_SIGNAL_SHUTDOWN


