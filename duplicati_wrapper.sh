#!/bin/bash

path=$1
authid=$2
passphrase=$3
retention=$4

/bin/date > $path/date.txt # this enforces backup execution

path_encoded="`echo ${path} | base32 | tr '=' '_'`"
hostname="`hostname`"
metrics_name="duplicati_${hostname}_`echo $path | tr '/' '_'`"
metrics_dir="/var/lib/prometheus/node-exporter/"

mkdir -p $metrics_dir
chown prometheus $metrics_dir

START="$(date +%s)"

EXITCODE=1

for i in `seq 10`
do
	/usr/bin/duplicati-cli backup "dropbox:///amaterasu/${hostname}${path}?authid=${authid}" "${path}" --backup-name="${path}" --dbpath="/var/duplicati_${path_encoded}.sqlite" --encryption-module=aes --compression-module=zip --dblock-size=50mb --passphrase="${passphrase}" --retention-policy="${retention}" --disable-module=console-password-input 
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
