from elkBackupUtil import *
from elkBackupAVS68Util import *

# print("ElasticSearch AVS66 Backup process staring...")
# config_dir=os.path.join(Path(os.getcwd()).parent.absolute(), 'config')
# elkBackupObj = elkBackupUtil()
# elkBackupObj.process(os.path.join(config_dir,'env.yaml'))
# print("Index process successfully completed")

print("ElasticSearch AVS68 Backup process staring...")
config_dir=os.path.join(Path(os.getcwd()).parent.absolute(), 'config')
elkBackupObj = elkBackupAVS68Util()
elkBackupObj.process(os.path.join(config_dir,'env.yaml'))
print("Index process successfully completed")