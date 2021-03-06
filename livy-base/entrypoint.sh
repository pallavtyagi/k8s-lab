#!/bin/bash

# include bpkg  dependencies
source /usr/local/bin/retry
source /usr/local/bin/bgo
source /usr/local/bin/bgowait

# global variables
GLOBAL_VAR="xyz"


##############################################################################
# validate if all container variables are set
##############################################################################
function validate(){
    vars="SPARK_MASTER_ENDPOINT SPARK_MASTER_PORT DEPLOY_MODE LIVY_VERSION SPARK_HOME"
    for var in $vars; do
        if [[ $(env | awk -F "=" '{print $1}' | grep "^$var$") != "$var" ]]; then
            echo "$var not set but required."
            return 1
        fi
    done
    if [[ -z ${GLOBAL_VAR+x} ]]; then
        echo "GLOBAL_VAR variable cannot be looked up."
        return 1
    fi
}

##############################################################################
# write config vars with configfile template
##############################################################################
function writeConfigOptions(){
    echo "write config options"
    export SPARK_MASTER_ENDPOINT=$SPARK_MASTER_ENDPOINT
    export SPARK_MASTER_PORT=$SPARK_MASTER_PORT
    export DEPLOY_MODE=$DEPLOY_MODE
    export LIVY_VERSION=$LIVY_VERSION

    cat /opt/docker-conf/livy.conf | envsubst > /opt/apache-livy-${LIVY_VERSION}-bin/conf/livy.conf
}

function init(){

    ## pre-config initialization

    # write file based config options
    writeConfigOptions



    ## post-config initialization

    ##TODO: check for Apache Spark if its running
}

##############################################################################



function livy_server_service(){

    export SPARK_HOME=$SPARK_HOME
    
    echo "starting Livy Server!"
    /opt/apache-livy-${LIVY_VERSION}-bin/bin/livy-server start

    # whatever blocking call
    tail -f /dev/null
}

function start(){

    bgo livy_server_service
    if [[ $? != 0 ]]; then
        echo "start failed. exiting now." >&2
        exit 1
    fi
}

##############################################################################
function configure(){
    echo "configure: ..."
    ## post-start configuration via service
}

##############################################################################
function main(){
    # validate env vars
    validate
    if [[ $? != 0 ]]; then
        echo "validation failed. exiting now." >&2
        exit 1
    fi

    # initialize
    init
    if [[ $? != 0 ]]; then
        echo "init failed. exiting now." >&2
        exit 1
    fi

    # start
    start
    if [[ $? != 0 ]]; then
        echo "start failed. exiting now." >&2
        exit 1
    fi

    # configure
    retry 5 5 "configure failed." configure
    if [[ $? != 0 ]]; then
        echo "cannot run configure." >&2
        exit 1
    fi

    # wait
    echo "done. now waiting for services."
    #freq=5; waitForN=-1; killTasks=0 # fail one, ignore (development mode)
    freq=5; waitForN=1; killTasks=1 #fail one, fail all (production mode)
    bgowait $freq $waitForN $killTasks
}

if [[ "$1" == "" ]]; then
    main
else
    exec "$@"
fi
