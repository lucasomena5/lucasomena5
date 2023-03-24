#!/bin/bash

echo "Removing old files"
rm -rf $HOME/bkp_pt_config/*json
echo "Files removed successfully"

DATE_WITH_TIME=$(date "+%Y%m%d-%H%M%S")
_HPA_CONFIG_JSON=$HOME/bkp_pt_config/bkp-config-autoscaling-avs68-$DATE_WITH_TIME.json
_NAMESPACE="avs-68"

echo "Collecting HPA configs..."

echo "{" >> $_HPA_CONFIG_JSON
echo "\"HPA\": [" >> $_HPA_CONFIG_JSON

for _HPA in $(kubectl -n $_NAMESPACE get hpa --no-headers | awk '{print $1}')
do 
  _TARGET_PERCENTAGE=$(kubectl -n $_NAMESPACE get hpa $_HPA --no-headers | awk '{print $3}' | cut -d '/' -f 2 | cut -d '%' -f 1)
  _MIN_REPLICAS=$(kubectl -n $_NAMESPACE get hpa $_HPA --no-headers | awk '{print $4}')
  _MAX_REPLICAS=$(kubectl -n $_NAMESPACE get hpa $_HPA --no-headers | awk '{print $5}') 
  
  if [[ $_HPA == "ws-message-dispatcher-hpa" ||  $_HPA == "telus-billing-ms-mem-hpa" || $_HPA == "telus-billing-ms-hpa" ]];
  then
        echo -e "\t\t\t\t{" >> $_HPA_CONFIG_JSON 
        echo -e "\t\t\t\t\t\t\"APPLICATION_NAME\": \"$_HPA\"," >> $_HPA_CONFIG_JSON 
        echo -e "\t\t\t\t\t\t\"AUTOSCALING_TYPE\": \"MEM\"," >> $_HPA_CONFIG_JSON 
        echo -e "\t\t\t\t\t\t\"MIN_RESOURCES\": \"$_MIN_REPLICAS\"," >> $_HPA_CONFIG_JSON 
        echo -e "\t\t\t\t\t\t\"MAX_RESOURCES\": \"$_MAX_REPLICAS\"," >> $_HPA_CONFIG_JSON 
        echo -e "\t\t\t\t\t\t\"TCPUU\": \"\"," >> $_HPA_CONFIG_JSON 
        echo -e "\t\t\t\t\t\t\"TMEMU\": \"$_TARGET_PERCENTAGE\"" >> $_HPA_CONFIG_JSON 
        echo -e "\t\t\t\t}," >> $_HPA_CONFIG_JSON 

  else
        echo -e "\t\t\t\t{" >> $_HPA_CONFIG_JSON 
        echo -e "\t\t\t\t\t\t\"APPLICATION_NAME\": \"$_HPA\"," >> $_HPA_CONFIG_JSON 
        echo -e "\t\t\t\t\t\t\"AUTOSCALING_TYPE\": \"CPU\"," >> $_HPA_CONFIG_JSON 
        echo -e "\t\t\t\t\t\t\"MIN_RESOURCES\": \"$_MIN_REPLICAS\"," >> $_HPA_CONFIG_JSON 
        echo -e "\t\t\t\t\t\t\"MAX_RESOURCES\": \"$_MAX_REPLICAS\"," >> $_HPA_CONFIG_JSON 
        echo -e "\t\t\t\t\t\t\"TCPUU\": \"$_TARGET_PERCENTAGE\"," >> $_HPA_CONFIG_JSON 
        echo -e "\t\t\t\t\t\t\"TMEMU\": \"\"" >> $_HPA_CONFIG_JSON 
        echo -e "\t\t\t\t}," >> $_HPA_CONFIG_JSON 

  fi
done

echo "]" >> $_HPA_CONFIG_JSON 
echo "}" >> $_HPA_CONFIG_JSON 

sed -i 's/\-hpa//g' $_HPA_CONFIG_JSON
sed -i 's/\-mem\-hpa//g' $_HPA_CONFIG_JSON

echo "HPA Collected successfully!"

_DEPLOYMENT_CONFIG_JSON=$HOME/bkp_pt_config/bkp-config-deployments-avs68-$DATE_WITH_TIME.json

echo "Collecting resources configs..."

echo "{" >> $_DEPLOYMENT_CONFIG_JSON
echo "\"DEPLOYMENTS\": [" >> $_DEPLOYMENT_CONFIG_JSON

for _DEPLOYMENT in $(kubectl -n $_NAMESPACE get deploy --no-headers | awk '{print $1}')
do 
  _CONTAINER=$(kubectl -n $_NAMESPACE get deploy $_DEPLOYMENT -o=jsonpath='{.spec.template.spec.containers[*].name}' | awk '{print $1}')
  _SECOND_CONTAINER=$(kubectl -n $_NAMESPACE get deploy $_DEPLOYMENT -o=jsonpath='{.spec.template.spec.containers[*].name}' | awk '{print $2}')
  
  if [[ $_SECOND_CONTAINER == "" ]];
  then 
    _LCPU=$(kubectl -n $_NAMESPACE get deploy $_DEPLOYMENT -o=jsonpath='{.spec.template.spec.containers[0].resources.limits.cpu}') 
    _LMEMORY=$(kubectl -n $_NAMESPACE get deploy $_DEPLOYMENT -o=jsonpath='{.spec.template.spec.containers[0].resources.limits.memory}') 
    _RCPU=$(kubectl -n $_NAMESPACE get deploy $_DEPLOYMENT -o=jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}')
    _RMEMORY=$(kubectl -n $_NAMESPACE get deploy $_DEPLOYMENT -o=jsonpath='{.spec.template.spec.containers[0].resources.requests.memory}')
    
    echo -e "\t\t\t{" >> $_DEPLOYMENT_CONFIG_JSON 
    echo -e "\t\t\t\t\"APPLICATION_NAME\": \"$_DEPLOYMENT\"," >> $_DEPLOYMENT_CONFIG_JSON 
    echo -e "\t\t\t\t\t\"RESOURCES\": {" >> $_DEPLOYMENT_CONFIG_JSON 
    echo -e "\t\t\t\t\t\t\"LIMITS\": {" >> $_DEPLOYMENT_CONFIG_JSON 
    echo -e "\t\t\t\t\t\t\t\"CPU\": \"$_LCPU\"," >> $_DEPLOYMENT_CONFIG_JSON 
    echo -e "\t\t\t\t\t\t\t\"MEMORY\": \"$_LMEMORY\"" >> $_DEPLOYMENT_CONFIG_JSON 
    echo -e "\t\t\t\t\t\t}," >> $_DEPLOYMENT_CONFIG_JSON 
    echo -e "\t\t\t\t\t\t\"REQUESTS\": {" >> $_DEPLOYMENT_CONFIG_JSON 
    echo -e "\t\t\t\t\t\t\t\"CPU\": \"$_RCPU\"," >> $_DEPLOYMENT_CONFIG_JSON 
    echo -e "\t\t\t\t\t\t\t\"MEMORY\": \"$_RMEMORY\"" >> $_DEPLOYMENT_CONFIG_JSON 
    echo -e "\t\t\t\t\t\t}" >> $_DEPLOYMENT_CONFIG_JSON 
    echo -e "\t\t\t\t\t}" >> $_DEPLOYMENT_CONFIG_JSON 
    echo -e "\t\t\t}," >> $_DEPLOYMENT_CONFIG_JSON 
      
  else 
        for i in $(seq 0 1);
        do
                if [ $i -eq 0 ];
                then 
                  _LCPU=$(kubectl -n $_NAMESPACE get deploy $_DEPLOYMENT -o=jsonpath="{.spec.template.spec.containers[$i].resources.limits.cpu}") 
                  _LMEMORY=$(kubectl -n $_NAMESPACE get deploy $_DEPLOYMENT -o=jsonpath="{.spec.template.spec.containers[$i].resources.limits.memory}") 
                  _RCPU=$(kubectl -n $_NAMESPACE get deploy $_DEPLOYMENT -o=jsonpath="{.spec.template.spec.containers[$i].resources.requests.cpu}")
                  _RMEMORY=$(kubectl -n $_NAMESPACE get deploy $_DEPLOYMENT -o=jsonpath="{.spec.template.spec.containers[$i].resources.requests.memory}")
                  
                  echo -e "\t\t\t{" >> $_DEPLOYMENT_CONFIG_JSON 
                  echo -e "\t\t\t\t\"APPLICATION_NAME\": \"$_DEPLOYMENT\"," >> $_DEPLOYMENT_CONFIG_JSON 
                  echo -e "\t\t\t\t\t\"RESOURCES\": {" >> $_DEPLOYMENT_CONFIG_JSON 
                  echo -e "\t\t\t\t\t\t\"LIMITS\": {" >> $_DEPLOYMENT_CONFIG_JSON 
                  echo -e "\t\t\t\t\t\t\t\"CPU\": \"$_LCPU\"," >> $_DEPLOYMENT_CONFIG_JSON 
                  echo -e "\t\t\t\t\t\t\t\"MEMORY\": \"$_LMEMORY\"" >> $_DEPLOYMENT_CONFIG_JSON 
                  echo -e "\t\t\t\t\t\t}," >> $_DEPLOYMENT_CONFIG_JSON 
                  echo -e "\t\t\t\t\t\t\"REQUESTS\": {" >> $_DEPLOYMENT_CONFIG_JSON 
                  echo -e "\t\t\t\t\t\t\t\"CPU\": \"$_RCPU\"," >> $_DEPLOYMENT_CONFIG_JSON 
                  echo -e "\t\t\t\t\t\t\t\"MEMORY\": \"$_RMEMORY\"" >> $_DEPLOYMENT_CONFIG_JSON 
                  echo -e "\t\t\t\t\t\t}" >> $_DEPLOYMENT_CONFIG_JSON 
                  echo -e "\t\t\t\t\t}" >> $_DEPLOYMENT_CONFIG_JSON 
                  echo -e "\t\t\t}," >> $_DEPLOYMENT_CONFIG_JSON
                else 
                  _LCPU=$(kubectl -n $_NAMESPACE get deploy $_DEPLOYMENT -o=jsonpath="{.spec.template.spec.containers[$i].resources.limits.cpu}") 
                  _LMEMORY=$(kubectl -n $_NAMESPACE get deploy $_DEPLOYMENT -o=jsonpath="{.spec.template.spec.containers[$i].resources.limits.memory}") 
                  _RCPU=$(kubectl -n $_NAMESPACE get deploy $_DEPLOYMENT -o=jsonpath="{.spec.template.spec.containers[$i].resources.requests.cpu}")
                  _RMEMORY=$(kubectl -n $_NAMESPACE get deploy $_DEPLOYMENT -o=jsonpath="{.spec.template.spec.containers[$i].resources.requests.memory}")
                  
                  echo -e "\t\t\t{" >> $_DEPLOYMENT_CONFIG_JSON 
                  echo -e "\t\t\t\t\"APPLICATION_NAME\": \"$_DEPLOYMENT-nginx\"," >> $_DEPLOYMENT_CONFIG_JSON 
                  echo -e "\t\t\t\t\t\"RESOURCES\": {" >> $_DEPLOYMENT_CONFIG_JSON 
                  echo -e "\t\t\t\t\t\t\"LIMITS\": {" >> $_DEPLOYMENT_CONFIG_JSON 
                  echo -e "\t\t\t\t\t\t\t\"CPU\": \"$_LCPU\"," >> $_DEPLOYMENT_CONFIG_JSON 
                  echo -e "\t\t\t\t\t\t\t\"MEMORY\": \"$_LMEMORY\"" >> $_DEPLOYMENT_CONFIG_JSON 
                  echo -e "\t\t\t\t\t\t}," >> $_DEPLOYMENT_CONFIG_JSON 
                  echo -e "\t\t\t\t\t\t\"REQUESTS\": {" >> $_DEPLOYMENT_CONFIG_JSON 
                  echo -e "\t\t\t\t\t\t\t\"CPU\": \"$_RCPU\"," >> $_DEPLOYMENT_CONFIG_JSON 
                  echo -e "\t\t\t\t\t\t\t\"MEMORY\": \"$_RMEMORY\"" >> $_DEPLOYMENT_CONFIG_JSON 
                  echo -e "\t\t\t\t\t\t}" >> $_DEPLOYMENT_CONFIG_JSON 
                  echo -e "\t\t\t\t\t}" >> $_DEPLOYMENT_CONFIG_JSON 
                  echo -e "\t\t\t}," >> $_DEPLOYMENT_CONFIG_JSON
                fi
        done
  fi
done

echo "]" >> $_DEPLOYMENT_CONFIG_JSON
echo "}" >> $_DEPLOYMENT_CONFIG_JSON

echo "Resources collected successfully!"

############################################################# ENV CONFIGS #############################################################
_ENV_CONFIG_JSON=$HOME/bkp_pt_config/bkp-env-config-avs68-$DATE_WITH_TIME.json

for _DEPLOYMENT in $(kubectl -n $_NAMESPACE get deploy --no-headers | awk '{print $1}')
do
  kubectl -n $_NAMESPACE get deploy $_DEPLOYMENT -ojson | jq '.spec.template.spec.containers[0].name, .spec.template.spec.containers[0].env' >> $_ENV_CONFIG_JSON
done

gsutil cp $HOME/bkp_pt_config/bkp-env-config-avs68-$DATE_WITH_TIME.json gs://avs68-prepr-database-dump-storage/bkp_gke_pt_configs/$(date "+%b-%d-%Y" | awk '{print tolower($1)}')/
gsutil cp $HOME/bkp_pt_config/bkp-config-deployments-avs68-$DATE_WITH_TIME.json gs://avs68-prepr-database-dump-storage/bkp_gke_pt_configs/$(date "+%b-%d-%Y" | awk '{print tolower($1)}')/
gsutil cp $HOME/bkp_pt_config/bkp-config-autoscaling-avs68-$DATE_WITH_TIME.json gs://avs68-prepr-database-dump-storage/bkp_gke_pt_configs/$(date "+%b-%d-%Y" | awk '{print tolower($1)}')/