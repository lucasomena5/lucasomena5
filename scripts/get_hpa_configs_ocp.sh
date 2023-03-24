#!/bin/bash

DATE_WITH_TIME=$(date "+%Y%m%d-%H%M%S")
_HPA_CONFIG_JSON=/product/tmp/scripts/autoscaling-$DATE_WITH_TIME.json

echo "`cat <<EOF
{
        "CONFIGURATIONS": [ 	
EOF`" >> $_HPA_CONFIG_JSON 

for _HPA in $(oc get hpa --no-headers | awk '{print $1}')
do 
  _TARGET_PERCENTAGE=$(oc get hpa $_HPA --no-headers | awk '{print $3}' | cut -d '/' -f 2)
  _MIN_REPLICAS=$(oc get hpa $_HPA --no-headers | awk '{print $4}')
  _MAX_REPLICAS=$(oc get hpa $_HPA --no-headers | awk '{print $5}') 
  
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