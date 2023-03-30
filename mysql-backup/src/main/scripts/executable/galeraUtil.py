import io
import json
import logging
import os
import paramiko
import sys
import time
import urllib.request
import mysql.connector as mysql

from datetime import datetime
from pathlib import Path
from envyaml import EnvYAML
from mysql.connector import Error

class GaleraUtil:


    def initialise_logger(self,loglevel):
        Log_Format = "%(levelname)s %(asctime)s - %(message)s"
        logging.basicConfig(stream = sys.stdout,
                                                filemode = "w",
                                                format = Log_Format,
                                                level = loglevel)
        self.log=logging.getLogger()
        self.log.info("Initialised logger in"+loglevel+" mode")

    def initialise(self,config_dir):
        env = EnvYAML(config_dir)
        self.initialise_logger(env['log_config.log_level'])
        self.log.debug("Start: initialise")
        self.timestamp = datetime.now().strftime("%m-%d-%Y%-H-%M-%S")
        #self.db_list = os.environ['TELUS_DB_BACKUP_NAME_LIST'].split(",")
        self.db_list = "avs-be-service-01,avs-be-service-02,avs-be-service-03".split(",") #Temp fix to overcome geo-redundancy temp node additions
        self.db_port=env['db_config.db_port']
        self.db_service_prefix=env['db_config.db_service_prefix']
        self.backup_script = None
        self.pkey = paramiko.RSAKey.from_private_key(io.StringIO(os.environ['TELUS_DB_SSH_KEY']))
        with open('../config/galera-configs.json', 'r') as f:
            jsonData = json.load(f)
        self.sshUser = jsonData[os.environ['TELUS_AVS_FQDN']][0]["service-account"]
        self.setHostEnvVars()
        self.log.debug("End: initialise")

    def cleanup(self):
        self.log.debug(" Start: cleanup")
        self.log.debug("End: cleanup")

    def runQueryAndVerify(self, nodeIp, verifyString, queryString):
        self.log.info("running query: %s", queryString)
        queryOK = False
        try:
            cnx = mysql.connect(user = os.environ['TELUS_DB_BACKUP_DB_USERNAME'], password = os.environ['TELUS_DB_BACKUP_DB_PASSWORD'],   host = nodeIp,   database = 'information_schema')
            cursor = cnx.cursor()
            cursor.execute(queryString)
            row = cursor.fetchone()
            self.log.info(str(row))
            if verifyString in str(row):
                self.log.info(str(row))
                queryOK = True
        except Error as e:
            self.log.debug(str(e))
        finally:
            cursor.close()
            cnx.close()
        return queryOK

    def setHostEnvVars(self):
        meta = 'http://169.254.169.254/latest/meta-data/ami-id'
        try:
            response = urllib.request.urlopen(meta, timeout=5).read()
            if 'ami' in str(response):
                self.log.debug("AWS VM detected")
                self.backup_script = "aws_galera_backup.sh"
                self.sshUser = "avs-user"
            else:
                self.log.debug("Defaultng to GCP VM")
                self.backup_script = "gcp_galera_backup.sh"
        except Exception as e:
            self.log.debug("Defaultng to GCP VM")
            self.log.error(str(e))
            self.backup_script = "gcp_galera_backup.sh"

    def run(self):
        self.log.info("Total DB Nodes identified: %d", len(self.db_list))
        with open('../config/galera-configs.json', 'r') as f:
            jsonData = json.load(f)

        logging.getLogger("paramiko").setLevel(logging.INFO)

        self.log.debug("Verifying if all DBs nodes are reachable")
        for db_service_name in self.db_list:
            nodeIp = jsonData[os.environ['TELUS_AVS_FQDN']][0][db_service_name]
            ssh = paramiko.SSHClient()
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            ssh.connect(nodeIp, username=self.sshUser, pkey=self.pkey, timeout=10)
            stdin, stdout, stderr = ssh.exec_command('ls')
            self.log.debug(stdout.readlines())
            ssh.close()

        self.log.debug("Verifying if all DBs are UP")
        for db_service_name in self.db_list:
            nodeIp = jsonData[os.environ['TELUS_AVS_FQDN']][0][db_service_name]
            resp = self.runQueryAndVerify(nodeIp, "Primary", "SHOW GLOBAL STATUS LIKE 'wsrep_cluster_status';")
            if (not resp):
                self.log.error("%s is unreachable"%db_service_name)
                os._exit(1)


        self.log.debug("Copy backup script to galera node 3")
        nodeIp = jsonData[os.environ['TELUS_AVS_FQDN']][0][self.db_list[2]]
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(nodeIp, username=self.sshUser, pkey=self.pkey, timeout=10)
        stdin, stdout, stderr = ssh.exec_command('mkdir -p /product/galera-backup')
        self.log.debug(stdout.readlines())
        ssh.close()

        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(nodeIp, username=self.sshUser, pkey=self.pkey, timeout=10)
        sftp = ssh.open_sftp()
        sftp.put("/tmp/src/deployments/executable/%s"%self.backup_script, "/product/galera-backup/db_backup.sh")
        sftp.close()
        ssh.close()

        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(nodeIp, username=self.sshUser, pkey=self.pkey, timeout=10)
        stdin, stdout, stderr = ssh.exec_command('chmod +x /product/galera-backup/db_backup.sh')
        self.log.debug(stdout.readlines())
        ssh.close()


        try:
            self.log.info("Preparing to remove node from active cluster")
            self.runQueryAndVerify(nodeIp, "", "SET GLOBAL wsrep_desync = ON; SET GLOBAL wsrep_on = OFF;")
            time.sleep(5)
            self.log.debug("Run backup script to galera node 3")
            ssh = paramiko.SSHClient()
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            ssh.connect(nodeIp, username=self.sshUser, pkey=self.pkey, timeout=10)
            transport = ssh.get_transport()
            transport.default_window_size = 2147483647
            transport.packetizer.REKEY_BYTES = pow(2, 40)
            transport.packetizer.REKEY_PACKETS = pow(2, 40)
            dbuser = os.environ['TELUS_DB_BACKUP_DB_USERNAME']
            dbPassword = os.environ['TELUS_DB_BACKUP_DB_PASSWORD']
            backupBucket = jsonData[os.environ['TELUS_AVS_FQDN']][0]["backup-bucket"]
            stdin, stdout, stderr = ssh.exec_command("/product/galera-backup/db_backup.sh %s %s %s >> /product/galera-backup/galera_backup_%s.log" %(dbuser, dbPassword, backupBucket, self.timestamp), timeout=4000)
            self.log.debug(stdout.readlines())
            ssh.close()
            ssh = paramiko.SSHClient()
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            ssh.connect(nodeIp, username=self.sshUser, pkey=self.pkey, timeout=10)
            stdin, stdout, stderr = ssh.exec_command('cat /product/galera-backup/galera_backup_%s.log' %self.timestamp)
            self.log.debug(stdout.readlines())
            ssh.close()            
        except Exception as e:
            self.log.error(e)
        finally:
            self.log.info("Preparing to add node back to active cluster")
            self.runQueryAndVerify(nodeIp, "", "SET GLOBAL wsrep_on = ON; SET GLOBAL wsrep_desync = OFF;")
            time.sleep(5)

    def process(self,config_dir):
        self.initialise(config_dir)
        self.run()
        self.cleanup()