import unittest
from unittest import mock
from unittest.mock import Mock
import sys
from google.cloud import storage
sys.path.append('../../../..')
from main.scripts.executable.elkBackupUtil import *

class TestelkBackup(unittest.TestCase):
    def setUp(self):
        self.test_geo_Ingestor=elkBackupUtil()
        self.test_geo_Ingestor.initialise_logger("INFO")


    def test_download_file_from_bucket(self):
         mock_client = mock.create_autospec(storage.Client)
         mock_bucket = mock.create_autospec(storage.Bucket)
         mock_bucket.name = 'test_bucket'
         mock_client.bucket.return_value = mock_bucket
         mock_blob = mock.create_autospec(storage.Blob)
         mock_blob.name = 'test_blob'
         mock_bucket.list_blobs.return_value = [mock_blob]
         self.assertTrue(self.test_geo_Ingestor.download_file_from_bucket(mock_client,mock_bucket,'',''))

    def test_download_file_from_empty_bucket(self):

        mock_client = mock.create_autospec(storage.Client)
        mock_bucket = mock.create_autospec(storage.bucket.Bucket)
        mock_bucket.name = 'test_bucket'
        mock_client.bucket.return_value = mock_bucket
        mock_bucket.list_blobs.return_value = []
        #mock_bucket.get_blob.return_value = mock_blob
        self.assertFalse(self.test_geo_Ingestor.download_file_from_bucket(mock_client,mock_bucket,'',''))


    def test_download_file_from_bucket_if_exception(self):
        mock_client = mock.create_autospec(storage.Client)
        mock_bucket = mock.create_autospec(storage.bucket.Bucket)
        mock_bucket.name = 'test_bucket'
        mock_client.bucket.return_value = mock_bucket
        mock_bucket.list_blobs.return_value = []
        mock_blob = mock.create_autospec(storage.Blob)
        mock_blob.name = 'test_blob'
        mock_bucket.list_blobs.return_value=Exception("test")
           #mock_bucket.get_blob.return_value = mock_blob
        self.assertFalse(self.test_geo_Ingestor.download_file_from_bucket(mock_client,mock_bucket,'',''))


    def test_upload_file_to_bucket(self):
        mock_client = mock.create_autospec(storage.Client)
        mock_bucket = mock.create_autospec(storage.bucket.Bucket)
        mock_bucket.name = 'test_bucket'
        mock_client.bucket.return_value = mock_bucket
        mock_blob = mock.create_autospec(storage.Blob)
        mock_bucket.blob.return_value=mock_blob
        from_folder=os.path.join(Path(os.getcwd()).parent.absolute(), 'test-resources')
        self.assertTrue(self.test_geo_Ingestor.upload_file_to_bucket(mock_client,mock_bucket,from_folder,'test-folder'))

    def test_upload_file_to_bucket_if_exception(self):
        mock_client = mock.create_autospec(storage.Client)
        mock_bucket = mock.create_autospec(storage.bucket.Bucket)
        mock_bucket.name = 'test_bucket'
        mock_client.bucket.return_value = mock_bucket
        mock_blob = mock.create_autospec(storage.Blob)
        mock_bucket.blob.return_value=Exception("test")
        from_folder=os.path.join(Path(os.getcwd()).parent.absolute(), 'test-resources')
        self.assertFalse(self.test_geo_Ingestor.upload_file_to_bucket(mock_client,mock_bucket,from_folder,'test-folder'))

    def test_mv_files_in_bucket(self):
        mock_client = mock.create_autospec(storage.Client)
        mock_bucket = mock.create_autospec(storage.bucket.Bucket)
        mock_bucket.name = 'test_bucket'
        mock_client.bucket.return_value = mock_bucket
        mock_blob = mock.create_autospec(storage.Blob)
        mock_blob.name = 'test_blob'
        mock_bucket.list_blobs.return_value = [mock_blob]
        self.assertTrue(self.test_geo_Ingestor.mv_files_in_bucket(mock_client,mock_bucket,'',''))

    def test_mv_files_in_bucket_if_exception(self):
        mock_client = mock.create_autospec(storage.Client)
        mock_bucket = mock.create_autospec(storage.bucket.Bucket)
        mock_client.bucket.return_value = mock_bucket
        mock_blob = mock.create_autospec(storage.Blob)
        mock_bucket.list_blobs.return_value = Exception("test")
        self.assertFalse(self.test_geo_Ingestor.mv_files_in_bucket(mock_client,mock_bucket,'',''))

if __name__ == '__main__':
    unittest.main()
