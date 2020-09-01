#! /bin/bash
. /etc/profile.d/oracle.sh
set

if [ ! -z $AWS_ENV_PATH ] ; then
   echo "Getting store params from parameter store"
   eval $(/usr/app/aws-env AWS_ENV_PATH AWS_REGION --recursive)
fi

SCRIPT_NAME=`basename ${0}`
SCRIPT_DIR=`dirname ${0}`
SCRIPT_RDIR=`(cd ${SCRIPT_DIR} ; pwd -P)`


function Echo() {
    local msg="${1}"
    local date=`date`
    echo "# ${SCRIPT_NAME} ${date}: ${msg}"
}



function Exit() {
    local rc=${1}
    local msg="${2}"
    if [ ${rc} -ne 0 ] ; then
       Echo "${msg}. RC=${rc}"
       exit ${rc}
    fi
}


set IHSMARKIT_AWS_XRAY_DAEMON-ADDRESS=localhost
echo "$(curl http://169.254.169.254/latest/meta-data/local-ipv4)  localhost" >> /etc/hosts
cat /etc/hosts
echo "Running X-Ray Daemon"
./xray -n us-east-1 --log-level warn &
sleep 5
echo "X-Ray daemon is running now"

echo "running applications"

cd /usr/app

java -XX:+HeapDumpOnOutOfMemoryError -Xmx4096m -Xss512k -javaagent:/usr/app/newrelic/newrelic.jar -jar razor-polling-service.jar 2>&1 | tee -a /usr/app/razor-polling-service.log

