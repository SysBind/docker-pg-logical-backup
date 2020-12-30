
# for azbak
export AZURE_STORAGE_ACCESS_KEY=$AZURE_STORAGE_KEY

function initialize {
    echo "Azure - init: STUB" >&2
}

function upload {
    echo "uploading $AZURE_CONTAINER_NAME/$1 " >&2
    azbak - /$AZURE_CONTAINER_NAME/$1
}

# list_backups
function list_backups {
    az storage blob list --container-name=$AZURE_CONTAINER_NAME | grep pg-logical- | cut -f4 -d'"' | cut -f1 -d"/" | uniq
}

# get_dump backup_number dump_name
function get_dump {
    az storage blob download --container $AZURE_CONTAINER_NAME --name $1 -f dumpfile > /dev/null
    cat dumpfile # still no luck piping..
}

# delete_backup backup_number
function delete_backup {
    for dump in  `az storage blob list --container-name=$AZURE_CONTAINER_NAME | grep pg-logical-$1 | cut -f4 -d'"' | cut -f1 -d"/"`; do
        echo "deleting old dump $AZURE_CONTAINER_NAME/$dump " >&2
        az storage blob delete --container-name=$AZURE_CONTAINER_NAME -n $dump
    done
}
