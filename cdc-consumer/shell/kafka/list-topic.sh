#! /bin/bash
docker exec -it \
    $(docker ps | grep kafkadbz | awk '{ print $1 }') \
    ./bin/kafka-topics.sh \
        --bootstrap-server localhost:9092 \
        --list