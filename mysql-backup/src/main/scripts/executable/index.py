from galeraUtil import *
from galeraAVS68Util import * 

# print("Galera AVS66 Backup process staring...")
# config_dir=os.path.join(Path(os.getcwd()).parent.absolute(), 'config')
# dbBackupObj = GaleraUtil()
# dbBackupObj.process(os.path.join(config_dir,'env.yaml'))
# print("Galera Backup process successfully completed")

print("Galera AVS68 Backup process staring...")
config_dir=os.path.join(Path(os.getcwd()).parent.absolute(), 'config')
dbBackupObj = GaleraAVS68Util()
dbBackupObj.process(os.path.join(config_dir,'env.yaml'))
print("Galera Backup process successfully completed")