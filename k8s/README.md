# Kubernetes Example

## GCS
First create a secret containing GCloud Service Account key file:
```kubectl create secret generic storage-svc-acc-key --from-file=gcskey.json```

Than edit Job.yaml and kubectl apply it.
