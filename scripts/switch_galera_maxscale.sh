Revert to npvr databases:

kubectl patch configmap datasources-properties --type=json -p='[{"op": "replace", "path": "/data/TELUS_LPVR_MS_DATASOURCE_SERVICE_NAME_LIST", "value": "avs-npvrbe-db-service-01,avs-npvrbe-db-service-02,avs-npvrbe-db-service-03,avs-npvrbe-db-service-04,avs-npvrbe-db-service-05,avs-npvrbe-db-service-06"}]'

oc rollout latest telus-lpvr-ms
oc rollout latest telus-lpvr-sync-ms

############################################################
Rever to proxysql:

kubectl patch configmap datasources-properties --type=json -p='[{"op": "replace", "path": "/data/TELUS_LPVR_MS_DATASOURCE_SERVICE_NAME_LIST", "value": "galeraserver"}]'

oc rollout latest telus-lpvr-ms
oc rollout latest telus-lpvr-sync-ms
