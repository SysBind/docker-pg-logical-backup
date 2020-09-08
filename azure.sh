
# for azbak
export AZURE_STORAGE_ACCESS_KEY=$AZURE_STORAGE_KEY

function authenticate {
    echo "azure - authenticate: STUB" >&2
}


function upload {
    echo "uploading $AZURE_CONTAINER_NAME/$1 " >&2
    azbak - /$AZURE_CONTAINER_NAME/$1
}

function backup_number {
    local number=0
    for line in `az storage blob list --container-name=$AZURE_CONTAINER_NAME | grep pg-logical- | cut -f4 -d'"' | cut -f1 -d"/" | uniq`; do
	echo -n "prev backup folder: $line..." >&2
	number=$((number+1))
    done
    echo -n $number
}


# For restoration functionality

# list_dumps backup_number
function list_dumps {
    az storage blob list --container-name=$AZURE_CONTAINER_NAME | grep pg-logical-$1 | cut -f4 -d'"'
}

# get_dump backup_number dump_name
function get_dump {
    az storage blob download --container $AZURE_CONTAINER_NAME --name pg-logical-$1/$2 -f dumpfile > /dev/null
    cat dumpfile # still no luck piping..
    rm x
}
