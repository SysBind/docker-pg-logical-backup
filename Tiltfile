# Tiltfile for docker-pg-logical-backup

load('ext://helm_remote', 'helm_remote')

helm_remote('minio', repo_url='https://helm.min.io/')
helm_remote('postgresql', 'https://charts.bitnami.com/bitnami',
            set=['image.tag=13'])
