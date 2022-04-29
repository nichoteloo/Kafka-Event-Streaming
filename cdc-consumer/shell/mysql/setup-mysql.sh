#! /bin/bash

# Script variables for global
: ${MYSQL_SCRIPT_PATH:="/home/nichotelo/Kafka_Test/mysql"}

# Scripts variables for source
: ${DOCKER_CONTAINER_NAME_SOURCE:=sourcedbz}
: ${DOCKER_USERNAME_SOURCE:=user_source}
: ${DOCKER_PASSWORD_SOURCE:=password}
: ${DOCKER_DATABASE_SOURCE:=source_test}

# Scripts variables for destination
: ${DOCKER_CONTAINER_NAME_DESTINATION:=destidbz}
: ${DOCKER_USERNAME_DESTINATION:=user_destination}
: ${DOCKER_PASSWORD_DESTINATION:=password}
: ${DOCKER_DATABASE_DESTINATION:=desti_test}


# ================== Check Container =====================
# Check container if exist
checkContainer() {
    # Get container ID
    CONTAINER_ID=$(docker container ls -qf "NAME=$1")

    # Check that we got an ID
    if [ ${#CONTAINER_ID} -lt 1 ]; then
        echo "ERROR: Container not found"; exit
    else
        echo "Container ${CONTAINER_ID} found!"
    fi
}

# Create table
createTable() {
    docker exec -i $1 mysql -u $2 -p$3 $4 < $5/create_table.sql
}


# ================== Source Container =====================
# Show global variable source
showSourceVar() {
    echo "Source variables"
    echo "Username source is $DOCKER_USERNAME_SOURCE"
    echo "Database source is $DOCKER_DATABASE_SOURCE"
}

# Copy config file
copyConfig() {
    echo "Create my.csf from host to container"
    docker cp config/my.cnf sourcedbz:/etc/mysql/conf.d/my.cnf
}


# ================= Destination Container =================
# Show global variable destination
showDestiVar() {
    echo "Destination variables"
    echo "Username destination is $DOCKER_USERNAME_DESTINATION"
    echo "Database destination is $DOCKER_DATABASE_DESTINATION"
}


# ================== Main Execution =====================
# Run functions
if [[ $# -eq 0 ]]; then
    echo "Check container source"
    checkContainer $DOCKER_CONTAINER_NAME_SOURCE

    echo

    echo "Check container destination"
    checkContainer $DOCKER_CONTAINER_NAME_DESTINATION

    echo

    showSourceVar

    echo

    showDestiVar

    echo

    echo "Move to mysql script directory"
    cd $MYSQL_SCRIPT_PATH

    echo

    copyConfig
    
    echo

    echo "Create source table"
    createTable $DOCKER_CONTAINER_NAME_SOURCE $DOCKER_USERNAME_SOURCE \
                 $DOCKER_PASSWORD_SOURCE $DOCKER_DATABASE_SOURCE "source"

    echo

    echo "Create destination table"
    createTable $DOCKER_CONTAINER_NAME_DESTINATION $DOCKER_USERNAME_DESTINATION \
                 $DOCKER_PASSWORD_DESTINATION $DOCKER_DATABASE_DESTINATION "destination"

    exit 0
fi