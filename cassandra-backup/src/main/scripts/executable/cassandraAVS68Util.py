import io
import json
import logging
import os
import paramiko
import sys
import urllib.request

from datetime import datetime
from pathlib import Path
from envyaml import EnvYAML

class CassandraAVS68Util:


    def initialise_logger(self,loglevel):
        Log_Format = "%(levelname)s %(asctime)s - %(message)s"
        logging.basicConfig(stream = sys.stdout,
                                                filemode = "w",
                                                format = Log_Format,
                                                level = loglevel)
        self.log=logging.getLogger()
        self.log.info("Initialised logger in "+loglevel+" mode - AVS 6.8")

    def initialise(self,config_dir):
        env = EnvYAML(config_dir)
        self.initialise_logger(env['log_config.log_level'])
        self.log.debug("Start: initialise")
        self.timestamp = datetime.now().strftime("%m-%d-%Y%-H-%M-%S")
        #self.db_list = os.environ['CASSANDRA_SERVICE_NAME_LIST'].split(",")
        self.db_list = "avs-wss-cassandra-db-service-01,avs-wss-cassandra-db-service-02,avs-wss-cassandra-db-service-03".split(",") #Temp fix to overcome geo-redundancy temp node additions
        self.pkey = paramiko.RSAKey.from_private_key(io.StringIO(os.environ['TELUS_DB_SSH_KEY']))
        #self.sshUser = "root"
        with open('../config/cassandra-avs68-configs.json', 'r') as f:
            jsonData = json.load(f)
        self.sshUser = jsonData[os.environ['TELUS_AVS_FQDN']][0]["service-account"]
        self.setHostEnvVars()
        self.log.debug("End: initialise")

    def cleanup(self):
        self.log.debug(" Start: cleanup")
        self.log.debug("End: cleanup")

    def setHostEnvVars(self):
        #meta = 'http://169.254.169.254/latest/meta-data/ami-id'
        try:
         #   response = urllib.request.urlopen(meta, timeout=5).read()
         #   if 'ami' in str(response):
         #       self.log.debug("AWS VM detected")
         #       self.sshUser = "avs-user"
         #   else:
            self.log.debug("Defaultng to GCP VM")
        except Exception as e:
            self.log.debug("Defaultng to GCP VM")
            self.log.error(str(e))

    def run(self):
        self.log.info("Total DB Nodes identified: %d", len(self.db_list))
        with open('../config/cassandra-avs68-configs.json', 'r') as f:
            jsonData = json.load(f)

        logging.getLogger("paramiko").setLevel(logging.INFO)

        self.log.debug("Verifying if all Cassandra nodes are reachable")
        for db_service_name in self.db_list:
            nodeIp = jsonData[os.environ['TELUS_AVS_FQDN']][0][db_service_name]
            ssh = paramiko.SSHClient()
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            ssh.connect(nodeIp, username=self.sshUser, pkey=self.pkey, timeout=10)
            stdin, stdout, stderr = ssh.exec_command('ls')
            self.log.debug(stdout.readlines())
            ssh.close()

        self.log.debug("Verifying if all Cassandra servers are UP")
        for db_service_name in self.db_list:
            self.log.info("running 'nodetool status' on %s"%db_service_name)
            nodeIp = jsonData[os.environ['TELUS_AVS_FQDN']][0][db_service_name]
            ssh = paramiko.SSHClient()
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            ssh.connect(nodeIp, username=self.sshUser, pkey=self.pkey, timeout=10)
            stdin, stdout, stderr = ssh.exec_command("/product/cassandra/bin/./nodetool status")
            resp = str(stdout.readlines())
            ssh.close()
            self.log.debug(resp)
            if nodeIp not in resp:
                self.log.error("cassandra response does not have address for %s" %db_service_name)
                os._exit(1)

        for db_service_name in self.db_list:
            nodeIp = jsonData[os.environ['TELUS_AVS_FQDN']][0][db_service_name]
            self.log.info("Copy backup script to cassandra node %s" %nodeIp)

            ssh = paramiko.SSHClient()
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            ssh.connect(nodeIp, username=self.sshUser, pkey=self.pkey, timeout=10)
            stdin, stdout, stderr = ssh.exec_command('mkdir -p /product/cassandra-backup')
            self.log.debug(stdout.readlines())
            ssh.close()

            ssh = paramiko.SSHClient()
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            ssh.connect(nodeIp, username=self.sshUser, pkey=self.pkey, timeout=10)
            sftp = ssh.open_sftp()
            sftp.put("/tmp/src/deployments/executable/cassandra_backup.sh", "/product/cassandra-backup/db_backup.sh")
            sftp.close()
            ssh.close()

            self.log.info("Add executable permissions to backup script on cassandra node %s" %nodeIp)
            ssh = paramiko.SSHClient()
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            ssh.connect(nodeIp, username=self.sshUser, pkey=self.pkey, timeout=10)
            stdin, stdout, stderr = ssh.exec_command('chmod +x /product/cassandra-backup/db_backup.sh')
            self.log.debug(stdout.readlines())
            ssh.close()

            try:
                self.log.debug("Running backup script on cassandra node %s" %nodeIp)
                ssh = paramiko.SSHClient()
                ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
                ssh.connect(nodeIp, username=self.sshUser, pkey=self.pkey, timeout=10)
                transport = ssh.get_transport()
                transport.default_window_size = 2147483647
                transport.packetizer.REKEY_BYTES = pow(2, 40)
                transport.packetizer.REKEY_PACKETS = pow(2, 40)
                backupBucket = jsonData[os.environ['TELUS_AVS_FQDN']][0]["backup-bucket"]
                stdin, stdout, stderr = ssh.exec_command("/product/cassandra-backup/db_backup.sh %s >> /product/cassandra-backup/cassandra_backup_%s.log" %(backupBucket, self.timestamp), timeout=4000)
                self.log.debug(stdout.readlines())
                ssh.close()
                ssh = paramiko.SSHClient()
                ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
                ssh.connect(nodeIp, username=self.sshUser, pkey=self.pkey, timeout=10)
                stdin, stdout, stderr = ssh.exec_command('cat /product/cassandra-backup/cassandra_backup_%s.log' %self.timestamp)
                self.log.debug(stdout.readlines())
                ssh.close()            
            except Exception as e:
                self.log.error(e)

    def process(self,config_dir):
        self.initialise(config_dir)
        self.run()
        self.cleanup()