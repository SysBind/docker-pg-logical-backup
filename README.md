# Generic PostgreSQL Backup/Restore Docker image
Image to execute logical backup per postgresql database and upload to buckets (S3, GCS or Azure Blobs)

## Env Vars
DAYS_KEEP - Default to 7, delete backups older than this value in days.

### PostgreSQL
PG_VERSION - 9.5, 9.6, 10, 11, 12 or 13

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




## Development

- [Kind](https://kind.sigs.k8s.io) or other local kubernetes.
- [Tilt](https://tilt.dev)

```kind create cluster```
```tilt up```

Cleanup (do this if things stops working):
```tilt down```
```kind destroy cluster```

