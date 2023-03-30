from cassandraUtil import * 
from cassandraAVS68Util import * 

# print("Cassandra AVS66 Backup process starting...")
# config_dir=os.path.join(Path(os.getcwd()).parent.absolute(), 'config')
# cassandraUtilObj = CassandraUtil()
# cassandraUtilObj.process(os.path.join(config_dir,'env.yaml'))
# print("Cassandra Backup process successfully completed")

print("Cassandra AVS68 Backup process starting...")
config_dir=os.path.join(Path(os.getcwd()).parent.absolute(), 'config')
cassandraUtilObj = CassandraAVS68Util()
cassandraUtilObj.process(os.path.join(config_dir,'env.yaml'))
print("Cassandra Backup process successfully completed")