import mysql.connector
from json import loads
from kafka import KafkaConsumer

def catchNone(x):
    if x is not None:
        return loads(x.decode('utf-8'))

# consumerFromLocal = KafkaConsumer(
#     'dbserver1.source_test.test',
#     bootstrap_servers=['0.0.0.0:29092'],
#     auto_offset_reset='latest',
#     enable_auto_commit=True,
#     group_id='2233',
#     value_deserializer=lambda x: catchNone(x)
# )

consumer = KafkaConsumer(
    'dbserver1.source_test.test',
    bootstrap_servers=['kafkadbz:9092'],
    auto_offset_reset='latest',
    enable_auto_commit=True,
    group_id='2233',
    value_deserializer=lambda x: catchNone(x)
)

config = {
    'host': 'destidbz',
    'port': 3306,
    'user': 'user_destination',
    'password': 'password',
    'database': 'desti_test'
}

mydb = mysql.connector.connect(
    host=config.get('host'),
    port=config.get('port'),
    user=config.get('user'),
    password=config.get('password'),
    database=config.get('database'),
    auth_plugin='mysql_native_password'
)

my_cursor = mydb.cursor()

for event in consumer:
    event_data = event.value
    # print(event_data)
    if event_data is not None:
        if event_data["payload"]["before"] is None:
            ## --- Insert Operation --- ##
            name = event_data["payload"]["after"]["name"]
            email = event_data["payload"]["after"]["email"]
            department = event_data["payload"]["after"]["department"]

            add_event = ("INSERT INTO test (name, email, department, updated_id) VALUES (%s, %s, %s, NULL)")
            data_event = (name, email, department)

            my_cursor.execute(add_event, data_event)
            ev_no = my_cursor.lastrowid

            print(f"new record inserted at row {ev_no}")
        elif event_data["payload"]["after"] is None:
            ## --- Delete Operation --- ##
            id_ = event_data["payload"]["before"]["id"] # should be the unique key

            my_cursor.execute("DELETE FROM test WHERE id = %s" % (id_,))

            print(f"row with index {id_} has successfully deleted")
        else:
            ## --- Update Operation --- ##
            id_ = event_data["payload"]["before"]["id"]
            name = event_data["payload"]["after"]["name"]
            email = event_data["payload"]["after"]["email"]
            department = event_data["payload"]["after"]["department"]
            
            add_event = ("INSERT INTO test (name, email, department, updated_id) VALUES (%s, %s, %s, %s)")
            data_event = (name, email, department, str(id_))

            my_cursor.execute(add_event, data_event)

            print(f"row with index {id_} has successfully updated")

        mydb.commit()

        # my_cursor.close()
        # mydb.close()

        # json_file = json.dumps(event_data, sort_keys=True, indent=4, separators=(",", ": "))
        # with open("response_delete.json", "w") as outfile:
        #     outfile.write(json_file)