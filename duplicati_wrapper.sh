#!/bin/bash

ACTION=$1
SRC_PATH=$2

source /etc/duplicati_wrapper.conf

PATH_ENCODED="`echo ${SRC_PATH} | base32 | tr '=' '_'`"
HOSTNAME="`hostname`"


if [[ "$1" ==  "backup" ]]; then
    metrics_name="duplicati_${HOSTNAME}_`echo $SRC_PATH | tr '/' '_'`"
    metrics_dir="/var/lib/prometheus/node-exporter/"

    mkdir -p $metrics_dir
    chown prometheus $metrics_dir

    /bin/date > $SRC_PATH/date.txt # this enforces backup execution

    START="$(date +%s)"

    EXITCODE=1

    for i in `seq 10`
    do
    	/usr/bin/duplicati-cli backup "dropbox:///${DROPBOX_MASTERPATH}/${HOSTNAME}${SRC_PATH}?authid=${DROPBOX_AUTHID}" "${SRC_PATH}" --backup-name="${SRC_PATH}" --dbpath="/var/duplicati_${PATH_ENCODED}.sqlite" --encryption-module=aes --compression-module=zip --dblock-size=50mb --passphrase="${DUPLICATI_PASSPHRASE}" --retention-policy="${DUPLICATI_RETENTION}" --disable-module=console-password-input 
    	EXITCODE=$?

    	if [ $EXITCODE -lt 10 ]
    	then
    		break
    	fi

    	sleep $((1 + RANDOM % 60))
    done

    END="$(date +%s)"

    cat << EOF > "$metrics_dir/${metrics_name}.prom.$$"
${metrics_name}_last_run_start $START
${metrics_name}_last_run_seconds $(($END - $START))
${metrics_name}_last_exitcode $EXITCODE
EOF

    mv "$metrics_dir/${metrics_name}.prom.$$" "$metrics_dir/${metrics_name}.prom"

elif [[ "$1" ==  "repair" ]]; then
    /usr/bin/duplicati-cli repair "dropbox:///${DROPBOX_MASTERPATH}/${HOSTNAME}${SRC_PATH}?authid=${DROPBOX_AUTHID}" --backup-name="${SRC_PATH}" --dbpath="/var/duplicati_${PATH_ENCODED}.sqlite" --encryption-module=aes --compression-module=zip --dblock-size=50mb --passphrase="${DUPLICATI_PASSPHRASE}" --retention-policy="${DUPLICATI_RETENTION}" --disable-module=console-password-input 
else
    echo "usage: $0 <backup,repair> SRC_PATH"
fi