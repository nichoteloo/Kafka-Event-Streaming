#! /bin/bash
docker exec -it \
  $(docker ps | grep kafkadbz | awk '{ print $1 }') \
  ./bin/kafka-console-consumer.sh \
    --bootstrap-server localhost:9092 \
    --topic dbserver1.source_test.test