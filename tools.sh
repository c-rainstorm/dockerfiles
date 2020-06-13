function createNetwork() {
    network=$1
    if [ `docker network ls --filter=name=${network} -q | wc -l` -eq 0 ]; then
        echo "Creating network [${network}]"
        docker network create ${network}
        echo "done"
    fi
}

function stopContainer(){
    CONTAINER_NAME=$1
    if [ `docker container ls --filter=name=${CONTAINER_NAME} -q | wc -l` -gt 0 ]; then
        echo "stopping container [${CONTAINER_NAME}]"
        docker container stop ${CONTAINER_NAME}
        echo "done"
    fi

    if [ `docker container ls -a --filter=name=${CONTAINER_NAME} -q | wc -l` -gt 0 ]; then
        echo "removing container [${CONTAINER_NAME}]"
        docker container rm ${CONTAINER_NAME}
        echo "done"
    fi
}

function ensureImageExsit() {
    image=$1
    if [ `docker images --filter=reference=${image} -q | wc -l` -eq 0 ]; then
        echo "Image [${image}] not found, try to pull"
        docker pull ${image}
        # $? = docker pull error code
        if [ $? -eq 0 ]; then
            echo "Image [${image}] pull success";
        else
            echo "Image [${image}] pull error! "
            exit 1;
        fi
    fi
}

function openUrlInBrowser () {
    URL=$1
    OS=`uname`
    if [ "${OS}" == "Darwin" ]; then
        open $URL
    elif [ "${OS}" == "Linux" ]; then
        xdg-open ${URL}
    fi
}
