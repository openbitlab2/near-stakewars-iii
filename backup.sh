#!/bin/bash

print_help () {
    echo "Usage: ./backup.sh -d /root/.near/data/ -b /root/chall14/backups/ -s neard.service
 -d  --data <dir> data directory to backup
 -b  --backup <dir> backups directory
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
	    DATE=$(date +%Y-%m-%d-%H-%M)
            backupdir="$2"
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

if [[ -z $backupdir || -z $datadir || -z $service ]]
then
    print_help
    exit 1
fi

DATE=$(date +%Y-%m-%d-%H-%M)
mkdir "${backupdir}near_${DATE}"

sudo systemctl stop $service
wait
echo "NEAR node was stopped" | ts

if [ -d "$backupdir" ]; then
    echo "Removing old backups" | ts 
    folders=$(ls "$backupdir" | grep -E "[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{2}-[0-9]{2}")
    for i in $folders; do
	if [[ "${backupdir}near_${DATE}" != *$i ]]; then
	    rm -rf "$backupdir$i"
	    echo "Deleted backup $i" | ts
	fi
    done
    echo "Backup started" | ts

    cd "${backupdir}near_${DATE}"
    tar -czf data.tar.gz -C $datadir .

    # Submit backup completion status, you can use healthchecks.io, betteruptime.com or other services
    # Example
    # curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/xXXXxXXx-XxXx-XXXX-XXXx-...

    echo "Backup completed" | ts
else
    echo $backupdir is not created. Check your permissions.
    exit 0
fi

sudo systemctl start $service
echo "NEAR node was started" | ts
