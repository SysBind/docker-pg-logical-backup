# Image to execute logical backup per postgresql database and upload to buckets (or save to volume)

## Env Vars

### PostgreSQL
PG_VERSION - 9.5, 9.6, 10, 11 or 12
PG_HOST, PG_USER, etc, See: https://www.postgresql.org/docs/12/libpq-envars.html


### Google Cloud
GCS_BUCKET - gs://BUCKET_NAME
GCS_KEYFILE - Path to Google Service Account Credentials, Should be injected into the container as a volume.
