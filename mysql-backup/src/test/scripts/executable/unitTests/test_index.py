import unittest
from unittest import mock
from unittest.mock import Mock
import sys
sys.path.append('../../../..')
from main.scripts.executable.galeraUtil import *
from main.scripts.executable.cassandraUtil import *

class TestdbBackup(unittest.TestCase):
    def setUp(self):
        self.test_dbUtil=GaleraUtil()
        self.test_cassandraUtil=CassandraUtil()
        self.config_dir=os.path.join(Path(os.getcwd()).parent.absolute(), 'config')


    def test_dbUtil(self):
        self.test_dbUtilLogger.initialise_logger("INFO")
        self.test_dbUtil.initialise(os.path.join(self.config_dir,'test_env.yaml'))
        self.test_dbUtil.cleanup()

    def test_cassandraUtil(self):
        self.test_cassandraUtil.initialise_logger("INFO")
        self.test_cassandraUtil.initialise(os.path.join(self.config_dir,'test_env.yaml'))
        self.test_cassandraUtil.cleanup()
        
if __name__ == '__main__':
    unittest.main()
