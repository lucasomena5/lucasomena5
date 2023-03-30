import sys
import json
from envyaml import EnvYAML
import logging
import sys
import requests
import os
from pathlib import Path
from datetime import datetime
import urllib.request

class elkBackupUtil:


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
        self.done_dir=env['directory_config.done_dir']
        self.elk_port=env['elk_config.elk_port']
        self.elk_service_prefix=env['elk_config.elk_service_prefix']
        self.elknode_count= env['elk_config.total_nodes']
        with open('../config/elk-avs66-configs.json', 'r') as f:
                  jsonData = json.load(f)
        self.nodeIp = jsonData[os.environ['TELUS_AVS_FQDN']][0]["avs-es-service-01"]
        self.log.debug("Done_dir:"+self.done_dir)
        self.log.debug("End: initialise")

    def cleanup(self):
        self.log.debug(" Start: cleanup")

    def getBackupCmd(self):
        meta = 'http://169.254.169.254/latest/meta-data/ami-id'
        dateTimeObj = datetime.now()
        timestampStr = dateTimeObj.strftime("%m-%d-%Y-%H-%M-%S").lower()
        try:
            response = urllib.request.urlopen(meta, timeout=5).read()
            if 'ami' in str(response):
                self.log.debug("AWS VM detected")
                _cmd = "_snapshot/my_s3_repository/snapshot_"+timestampStr+"?wait_for_completion=true".lower()
            else:
                self.log.debug("Defaultng to GCP VM")
                _cmd = '_snapshot/backup/snapshot_'+timestampStr
        except Exception as nometa:
            self.log.debug("Defaultng to GCP VM")
            _cmd = '_snapshot/backup/snapshot_'+timestampStr

        return _cmd

    def run(self):
        elknode_count = int(self.elknode_count)
        self.log.info("Total ELK Nodes identified: %d", elknode_count)

        self.log.debug("Verifying if all nodes are healthy")
        try:
            for x in range(elknode_count):
                x = x + 1
                nodeId = ('%02d' % x)
                url = "https://%s-%s:%s/_cat/health" %(self.elk_service_prefix, str(nodeId), self.elk_port)
                self.log.debug("Verifying elk on node %s", url)
                resp = requests.get(url, verify=False)
                self.log.info("Response Code: %s", str(resp.status_code))
                if resp.status_code != 200:
                    self.log.error("ELK node %s is unreachable", url)
                    sys.exit("ELK node %s is unreachable"% url)
                self.log.debug("Response Text: %s", str(resp.text))
                self.log.debug("Response URL: %s", str(resp.url))
        except:
            self.log.info("elk node could be unhealthy")

        bkpCmd = self.getBackupCmd()
        backupSuccess = False
        
        self.log.info("Taking elk backup on elk node 01")
        url = "https://%s:%s/%s" %(self.nodeIp, self.elk_port, bkpCmd)
        self.log.debug("Taking backup from elk node %s", url)
        resp = requests.put(url, verify=False, timeout=600)
        self.log.info("Response Code: %s", str(resp.status_code))
        if resp.status_code == 200:
            self.log.info("ELK backup from node 01 was successful")
            backupSuccess = True
            self.log.debug(str(resp))
        elif resp.status_code != 200:
            self.log.debug("ELK backup from node 01 failed")
            self.log.debug(str(resp))
        if backupSuccess == False:
            self.log.error("ELK backup failed")
            self.log.debug("Check: https://telusvideoservices.atlassian.net/wiki/spaces/AD/pages/1128530147/Elasticsearch+Snapshot+Restore")
            sys.exit("ELK backup failed")

    def process(self,config_dir):
        self.initialise(config_dir)
        resp = self.run()
        self.log.debug(str(resp))
        self.cleanup()
