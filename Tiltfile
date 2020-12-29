# Tiltfile for docker-pg-logical-backup

k8s_yaml(helm('tests/charts/minio', name="minio"))
k8s_yaml(helm('tests/charts/postgresql', name="postgresql",              
              set=['postgresqlPassword=q1w2e3r4', 'image.tag=13']))

docker_build('sysbind/pg-logical-backup', '.')

k8s_yaml('tests/populate.job.yaml')
k8s_yaml('tests/backup.job.yaml')
