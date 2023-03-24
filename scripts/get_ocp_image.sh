#!/bin/bash

for _DC in $(oc get dc --no-headers | awk '{print $1}')
do 
  _IMAGE=$(oc get dc $_DC -ojson | jq .spec.triggers[].imageChangeParams.from.name | head -1)
  echo $_IMAGE
done