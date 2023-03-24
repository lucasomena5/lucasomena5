#!/bin/bash

DATE_WITH_TIME=$(date "+%Y%m%d-%H%M%S")
_DEPLOYMENT_CONFIG_JSON=/tmp/deployments-$DATE_WITH_TIME.json

echo "`cat <<EOF
{
        "DEPLOYMENTS": [ 	
EOF`" >> $_DEPLOYMENT_CONFIG_JSON 

for _DEPLOYMENT in $(kubectl -n avs-68 get deploy --no-headers | awk '{print $1}')
do 
  _CONTAINER=$(kubectl -n avs-68 get deploy $_DEPLOYMENT -o=jsonpath='{.spec.template.spec.containers[*].name}' | awk '{print $1}')
  _SECOND_CONTAINER=$(kubectl -n avs-68 get deploy $_DEPLOYMENT -o=jsonpath='{.spec.template.spec.containers[*].name}' | awk '{print $2}')
  
  if [[ $_SECOND_CONTAINER == "" ]];
  then 
	_LCPU=$(kubectl -n avs-68 get deploy $_DEPLOYMENT -o=jsonpath='{.spec.template.spec.containers[0].resources.limits.cpu}') 
    _LMEMORY=$(kubectl -n avs-68 get deploy $_DEPLOYMENT -o=jsonpath='{.spec.template.spec.containers[0].resources.limits.memory}') 
    _RCPU=$(kubectl -n avs-68 get deploy $_DEPLOYMENT -o=jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}')
    _RMEMORY=$(kubectl -n avs-68 get deploy $_DEPLOYMENT -o=jsonpath='{.spec.template.spec.containers[0].resources.requests.memory}')
    
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
		  _LCPU=$(kubectl -n avs-68 get deploy $_DEPLOYMENT -o=jsonpath="{.spec.template.spec.containers[$i].resources.limits.cpu}") 
		  _LMEMORY=$(kubectl -n avs-68 get deploy $_DEPLOYMENT -o=jsonpath="{.spec.template.spec.containers[$i].resources.limits.memory}") 
		  _RCPU=$(kubectl -n avs-68 get deploy $_DEPLOYMENT -o=jsonpath="{.spec.template.spec.containers[$i].resources.requests.cpu}")
		  _RMEMORY=$(kubectl -n avs-68 get deploy $_DEPLOYMENT -o=jsonpath="{.spec.template.spec.containers[$i].resources.requests.memory}")
		  
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
		  _LCPU=$(kubectl -n avs-68 get deploy $_DEPLOYMENT -o=jsonpath="{.spec.template.spec.containers[$i].resources.limits.cpu}") 
		  _LMEMORY=$(kubectl -n avs-68 get deploy $_DEPLOYMENT -o=jsonpath="{.spec.template.spec.containers[$i].resources.limits.memory}") 
		  _RCPU=$(kubectl -n avs-68 get deploy $_DEPLOYMENT -o=jsonpath="{.spec.template.spec.containers[$i].resources.requests.cpu}")
		  _RMEMORY=$(kubectl -n avs-68 get deploy $_DEPLOYMENT -o=jsonpath="{.spec.template.spec.containers[$i].resources.requests.memory}")
		  
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

echo "`cat <<EOF
        ]
} 
EOF`" >> $_DEPLOYMENT_CONFIG_JSON