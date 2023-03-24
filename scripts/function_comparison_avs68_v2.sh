#!/bin/bash

getImages () {
  
DATE_WITH_TIME=$(date "+%Y%m%d-%H%M%S")
_IMAGE_CONFIG_JSON=/home/lucas_dossantosomena/images-$DATE_WITH_TIME.json

echo "`cat <<EOF
{
        "IMAGES": [ 	
EOF`" >> $_IMAGE_CONFIG_JSON 

for _DEPLOY in $(/tmp/kubectl -n avs-68 get deploy --no-headers | awk '{print $1}')
do 
  _IMAGE=$(/tmp/kubectl -n avs-68 get deploy $_DEPLOY -ojson | jq .spec.template.spec.containers[].image | head -1 | cut -d "/" -f 4)
  echo -e "\t\t\t{" >> $_IMAGE_CONFIG_JSON 
  echo -e "\t\t\t\t\"APPLICATION_NAME\": \"$_DEPLOY\"," >> $_IMAGE_CONFIG_JSON 
  echo -e "\t\t\t\t\"IMAGE_VERSION\": \"$_IMAGE" >> $_IMAGE_CONFIG_JSON 
  echo -e "\t\t\t}," >> $_IMAGE_CONFIG_JSON 
done

echo "`cat <<EOF
        ]
} 
EOF`" >> $_IMAGE_CONFIG_JSON

}

getResources () {

DATE_WITH_TIME=$(date "+%Y%m%d-%H%M%S")
_DEPLOYMENT_CONFIG_JSON=/home/lucas_dossantosomena/deployments-$DATE_WITH_TIME.json

echo "`cat <<EOF
{
        "DEPLOYMENTS": [ 	
EOF`" >> $_DEPLOYMENT_CONFIG_JSON 

for _DEPLOYMENT in $(/tmp/kubectl -n avs-68 get deploy --no-headers | awk '{print $1}')
do 
  _CONTAINER=$(/tmp/kubectl -n avs-68 get deploy $_DEPLOYMENT -o=jsonpath='{.spec.template.spec.containers[*].name}' | awk '{print $1}')
  _SECOND_CONTAINER=$(/tmp/kubectl -n avs-68 get deploy $_DEPLOYMENT -o=jsonpath='{.spec.template.spec.containers[*].name}' | awk '{print $2}')
  
  if [[ $_SECOND_CONTAINER == "" ]];
  then 
	_LCPU=$(/tmp/kubectl -n avs-68 get deploy $_DEPLOYMENT -o=jsonpath='{.spec.template.spec.containers[0].resources.limits.cpu}') 
    _LMEMORY=$(/tmp/kubectl -n avs-68 get deploy $_DEPLOYMENT -o=jsonpath='{.spec.template.spec.containers[0].resources.limits.memory}') 
    _RCPU=$(/tmp/kubectl -n avs-68 get deploy $_DEPLOYMENT -o=jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}')
    _RMEMORY=$(/tmp/kubectl -n avs-68 get deploy $_DEPLOYMENT -o=jsonpath='{.spec.template.spec.containers[0].resources.requests.memory}')
    
    echo -e "\t\t\t{" >> $_DEPLOYMENT_CONFIG_JSON 
    echo -e "\t\t\t\t\"APPLICATION_NAME\": \"$_DEPLOYMENT\"," >> $_DEPLOYMENT_CONFIG_JSON 
    echo -e "\t\t\t\t\t\"RESOURCES\": {" >> $_DEPLOYMENT_CONFIG_JSON 
    echo -e "\t\t\t\t\t\t\"LIMITS\": {" >> $_DEPLOYMENT_CONFIG_JSON 
    echo -e "\t\t\t\t\t\t\t\"CPU\": \"$_LCPU\"," >> $_DEPLOYMENT_CONFIG_JSON 
    echo -e "\t\t\t\t\t\t\t\"MEMORY\": \"$_LMEMORY\"," >> $_DEPLOYMENT_CONFIG_JSON 
    echo -e "\t\t\t\t\t\t}," >> $_DEPLOYMENT_CONFIG_JSON 
    echo -e "\t\t\t\t\t\t\"REQUESTS\": {" >> $_DEPLOYMENT_CONFIG_JSON 
    echo -e "\t\t\t\t\t\t\t\"CPU\": \"$_RCPU\"," >> $_DEPLOYMENT_CONFIG_JSON 
    echo -e "\t\t\t\t\t\t\t\"MEMORY\": \"$_RMEMORY\"," >> $_DEPLOYMENT_CONFIG_JSON 
    echo -e "\t\t\t\t\t\t}" >> $_DEPLOYMENT_CONFIG_JSON 
    echo -e "\t\t\t\t\t}" >> $_DEPLOYMENT_CONFIG_JSON 
    echo -e "\t\t\t}," >> $_DEPLOYMENT_CONFIG_JSON 
  
  else 
	for i in $(seq 0 1);
	do	
		if [ $i -eq 0 ];
		then 
		  _LCPU=$(/tmp/kubectl -n avs-68 get deploy $_DEPLOYMENT -o=jsonpath="{.spec.template.spec.containers[$i].resources.limits.cpu}") 
		  _LMEMORY=$(/tmp/kubectl -n avs-68 get deploy $_DEPLOYMENT -o=jsonpath="{.spec.template.spec.containers[$i].resources.limits.memory}") 
		  _RCPU=$(/tmp/kubectl -n avs-68 get deploy $_DEPLOYMENT -o=jsonpath="{.spec.template.spec.containers[$i].resources.requests.cpu}")
		  _RMEMORY=$(/tmp/kubectl -n avs-68 get deploy $_DEPLOYMENT -o=jsonpath="{.spec.template.spec.containers[$i].resources.requests.memory}")
		  
		  echo -e "\t\t\t{" >> $_DEPLOYMENT_CONFIG_JSON 
		  echo -e "\t\t\t\t\"APPLICATION_NAME\": \"$_DEPLOYMENT\"," >> $_DEPLOYMENT_CONFIG_JSON 
		  echo -e "\t\t\t\t\t\"RESOURCES\": {" >> $_DEPLOYMENT_CONFIG_JSON 
		  echo -e "\t\t\t\t\t\t\"LIMITS\": {" >> $_DEPLOYMENT_CONFIG_JSON 
		  echo -e "\t\t\t\t\t\t\t\"CPU\": \"$_LCPU\"," >> $_DEPLOYMENT_CONFIG_JSON 
		  echo -e "\t\t\t\t\t\t\t\"MEMORY\": \"$_LMEMORY\"," >> $_DEPLOYMENT_CONFIG_JSON 
		  echo -e "\t\t\t\t\t\t}," >> $_DEPLOYMENT_CONFIG_JSON 
		  echo -e "\t\t\t\t\t\t\"REQUESTS\": {" >> $_DEPLOYMENT_CONFIG_JSON 
		  echo -e "\t\t\t\t\t\t\t\"CPU\": \"$_RCPU\"," >> $_DEPLOYMENT_CONFIG_JSON 
		  echo -e "\t\t\t\t\t\t\t\"MEMORY\": \"$_RMEMORY\"," >> $_DEPLOYMENT_CONFIG_JSON 
		  echo -e "\t\t\t\t\t\t}" >> $_DEPLOYMENT_CONFIG_JSON 
		  echo -e "\t\t\t\t\t}" >> $_DEPLOYMENT_CONFIG_JSON 
		  echo -e "\t\t\t}," >> $_DEPLOYMENT_CONFIG_JSON
		else 
		  _LCPU=$(/tmp/kubectl -n avs-68 get deploy $_DEPLOYMENT -o=jsonpath="{.spec.template.spec.containers[$i].resources.limits.cpu}") 
		  _LMEMORY=$(/tmp/kubectl -n avs-68 get deploy $_DEPLOYMENT -o=jsonpath="{.spec.template.spec.containers[$i].resources.limits.memory}") 
		  _RCPU=$(/tmp/kubectl -n avs-68 get deploy $_DEPLOYMENT -o=jsonpath="{.spec.template.spec.containers[$i].resources.requests.cpu}")
		  _RMEMORY=$(/tmp/kubectl -n avs-68 get deploy $_DEPLOYMENT -o=jsonpath="{.spec.template.spec.containers[$i].resources.requests.memory}")
		  
		  echo -e "\t\t\t{" >> $_DEPLOYMENT_CONFIG_JSON 
		  echo -e "\t\t\t\t\"APPLICATION_NAME\": \"$_DEPLOYMENT-nginx\"," >> $_DEPLOYMENT_CONFIG_JSON 
		  echo -e "\t\t\t\t\t\"RESOURCES\": {" >> $_DEPLOYMENT_CONFIG_JSON 
		  echo -e "\t\t\t\t\t\t\"LIMITS\": {" >> $_DEPLOYMENT_CONFIG_JSON 
		  echo -e "\t\t\t\t\t\t\t\"CPU\": \"$_LCPU\"," >> $_DEPLOYMENT_CONFIG_JSON 
		  echo -e "\t\t\t\t\t\t\t\"MEMORY\": \"$_LMEMORY\"," >> $_DEPLOYMENT_CONFIG_JSON 
		  echo -e "\t\t\t\t\t\t}," >> $_DEPLOYMENT_CONFIG_JSON 
		  echo -e "\t\t\t\t\t\t\"REQUESTS\": {" >> $_DEPLOYMENT_CONFIG_JSON 
		  echo -e "\t\t\t\t\t\t\t\"CPU\": \"$_RCPU\"," >> $_DEPLOYMENT_CONFIG_JSON 
		  echo -e "\t\t\t\t\t\t\t\"MEMORY\": \"$_RMEMORY\"," >> $_DEPLOYMENT_CONFIG_JSON 
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

}

getHPA () {

DATE_WITH_TIME=$(date "+%Y%m%d-%H%M%S")
_HPA_CONFIG_JSON=/home/lucas_dossantosomena/hpa-$DATE_WITH_TIME.json

echo "`cat <<EOF
{
        "CONFIGURATIONS": [ 	
EOF`" >> $_HPA_CONFIG_JSON 

for _HPA in $(/tmp/kubectl -n avs-68 get hpa --no-headers | awk '{print $1}')
do 
  _TARGET_PERCENTAGE=$(/tmp/kubectl -n avs-68 get hpa $_HPA --no-headers | awk '{print $3}' | cut -d '/' -f 2)
  _MIN_REPLICAS=$(/tmp/kubectl -n avs-68 get hpa $_HPA --no-headers | awk '{print $4}')
  _MAX_REPLICAS=$(/tmp/kubectl -n avs-68 get hpa $_HPA --no-headers | awk '{print $5}') 
  
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

echo "`cat <<EOF
        ]
} 
EOF`" >> $_HPA_CONFIG_JSON

sed -i 's/\%//g' $_HPA_CONFIG_JSON
sed -i 's/\-hpa//g' $_HPA_CONFIG_JSON
sed -i 's/\-mem\-hpa//g' $_HPA_CONFIG_JSON

}

getConfigMaps () {

DATE_WITH_TIME=$(date "+%Y%m%d-%H%M%S")
_CONFIGMAP_CONFIG_JSON=/home/lucas_dossantosomena/configmap-$DATE_WITH_TIME.json

for _CONFIGMAP in $(/tmp/kubectl -n avs-68 get cm | awk '{print $1}' | grep -vE "properties-1|-1|-2|-3|-4|-5|-6|-7|-8|-9|avs-68")
do   
  /tmp/kubectl -n avs-68 get cm $_CONFIGMAP -ojson | jq '.metadata.name,.data' >> $_CONFIGMAP_CONFIG_JSON
done

}
######################################## CALL FUNCTIONS ####################################################

getImages
getResources
getHPA
getConfigMaps