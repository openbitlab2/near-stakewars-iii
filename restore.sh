#!/bin/bash

print_help () {
    echo "Usage: ./restore.sh -d /root/.near/data/ -b /root/chall14/backups/ -s neard.service
 -d  --data <dir> data directory where to restore
 -b  --backup <file> backup archive
 -s  --service <name> service name file"
}

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
case $1 in
    -b|--backup)
        if [[ -z $2 ]]
        then
            print_help
            exit 1
        else
            backuparchive="$2"
        fi
        shift # past argument
        shift # past value
    ;;
    -d|--data)
        if [[ -z $2 ]]
        then
            print_help
            exit 1
        else 
	    datadir="$2"
	fi
        shift # past argument
        shift # past value
    ;;
    -s|--service)
        if [[ -z $2 ]]
        then
            print_help
            exit 1
        else 
	    service="$2"
	fi
        shift # past argument
    ;;
    -*|--*)
        echo "Unknown option $1"
        print_help
        exit 1
    ;;
    *)
        POSITIONAL_ARGS+=("$1") # save positional arg
        shift # past argument
    ;;
esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

if [[ -z $backuparchive || -z $datadir || -z $service ]]
then
    print_help
    exit 1
fi

DATE=$(date +%Y-%m-%d-%H-%M)

sudo systemctl stop $service
wait
echo "NEAR node was stopped" | ts

if [ -f "$backuparchive" ]; then
    echo "Removing old data folder" | ts 
    rm -rf $datadir
    echo "Removed old data folder" | ts

    echo "Restore started" | ts

    mkdir $datadir
    tar -xf $backuparchive -C $datadir

    echo "Restore completed" | ts
else
    echo $BACKUPARCHIVE is not created. Check your permissions.
    exit 0
fi

sudo systemctl start $service
echo "NEAR node was started" | ts
