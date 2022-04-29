# Kafka CDC between MySQL databases

**DEVELOPMENT**
### Start several services at first
`docker-compose up -d source destination zookeeper kafka connect`

### Configure mysql setup
`./shell/mysql/setup-mysql.sh`

### Create CDC connector
`./shell/connector/create-cdc-conn.sh`

### List all connectors
`./shell/connector/list-connectors.sh`

### Check connector status
`./shell/connector/connector-status.sh`

### List all topics
`./shell/kafka/list-topic.sh`

### Start debug kafka consumer
`./shell/kafka/track-consumer.sh`

### Create new terminal and run consumer node
`docker-compose up -d consumer_node`

### Make changes in source db
`docker exec -it sourcedbz mysql -u user_source -ppassword -D source_test -e "${command-in-mysql/source/action_test.sql}"`

### View the records in destination db
`docker exec -it destidbz mysql -u user_destination -ppassword -D desti_test -e "SELECT * FROM test;"`

**PRODUCTION**
### Start several services at first
`docker-compose up -d zookeeper kafka connect`

### Create CDC connector
`./shell/connector/create-cdc-conn.sh`

### List all connectors
`./shell/connector/list-connectors.sh`

### Check connector status
`./shell/connector/connector-status.sh`

### List all topics
`./shell/kafka/list-topic.sh`

### Start debug kafka consumer
`./shell/kafka/track-consumer.sh`

### Create new terminal and run consumer node
`docker-compose up -d consumer_node`

