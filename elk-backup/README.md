# Snapshot and restore

A snapshot is a backup of a running Elasticsearch cluster. You can use snapshots to:

Regularly back up a cluster with no downtime
Recover data after deletion or a hardware failure
Transfer data between clusters

### The snapshot workflow
Elasticsearch stores snapshots in an off-cluster storage location called a snapshot repository. Before you can take or restore snapshots, you must register a snapshot repository on the cluster. 
Elasticsearch supports several repository types with cloud storage options, including:

AWS S3
Google Cloud Storage (GCS)

After you register a snapshot repository, you can use snapshot lifecycle management (SLM) to automatically take and manage snapshots. You can then restore a snapshot to recover or transfer its data.

### How snapshots work
Snapshots are automatically deduplicated to save storage space and reduce network transfer costs. To back up an index, a snapshot makes a copy of the index’s segments and stores them in the snapshot repository. Since segments are immutable, the snapshot only needs to copy any new segments created since the repository’s last snapshot.

Each snapshot is also logically independent. When you delete a snapshot, Elasticsearch only deletes the segments used exclusively by that snapshot. Elasticsearch doesn’t delete segments used by other snapshots in the repository.

### How to configure Backup on AWS?

https://telusvideoservices.atlassian.net/wiki/spaces/AD/pages/1128530147/Elasticsearch+Snapshot+Restore

### How to configure Backup on GCS?
- Create a service account on GCP with roles/storage.objectAdmin
- Add the service account to elasticsearch-keystore
	* sudo as 'elasticsearch' user
    * elasticsearch-keystore add-file gcs.client.default.credentials_file <service-account.json> (on all ELK Nodes)
	* elasticsearch-plugin install repository-gcs (on all ELK Nodes)
	* systemctl restart elasticsearch (on all ELK Nodes)
	* Create a backup repository (from one of the ELK Nodes): 
		curl -X POST "https://localhost:9200/_snapshot/backup" -H 'Content-Type: application/json' -d '{ "type": "gcs", "settings": { "bucket": "avs66-dev-elk-backup", "base_path": "telusdevelk1", "client": "default" } }' -k

	* Taking Backup: 
		curl -X PUT "https://localhost:9200/_snapshot/backup/snapshot_`date +'%Y_%m_%d'`" -k
		
	* Restore:
		curl -X POST 'localhost:9200/_snapshot/backup/snapshot_2022_01_05/_restore'


- Quick summary
- Version
- [Learn Markdown](https://bitbucket.org/tutorials/markdowndemo)


### How to build Docker base image
docker build -t python39-telus .
docker tag python39-telus:latest docker-registry.default.svc:5000/openshift/python39:latest
docker login -u `oc whoami` -p `oc whoami --show-token` docker-registry.default.svc:5000
docker push docker-registry.default.svc:5000/openshift/python39:latest

### Contribution guidelines

- Writing tests
- Code review
- Other guidelines

### Who do I talk to?

- Frictionless AVS9
