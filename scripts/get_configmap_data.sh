#!/bin/bash

DATE_WITH_TIME=$(date "+%Y%m%d-%H%M%S")
_CONFIGMAP_CONFIG_JSON=/product/tmp/scripts/configmap-$DATE_WITH_TIME.json

for _CONFIGMAP in $(oc get cm --no-headers | awk '{print $1}')
do   
  oc get cm $_CONFIGMAP -ojson | jq '.metadata.name,.data' >> $_CONFIGMAP_CONFIG_JSON

done