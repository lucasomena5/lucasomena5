#!/bin/bash

DATE_WITH_TIME=$(date "+%Y%m%d-%H%M%S")
_IMAGE_CONFIG_JSON=/product/tmp/scripts/images-$DATE_WITH_TIME.json

echo "`cat <<EOF
{
        "IMAGES": [ 	
EOF`" >> $_IMAGE_CONFIG_JSON 

for _DC in $(oc get dc --no-headers | awk '{print $1}')
do 
  _IMAGE=$(oc get dc $_DC -ojson | jq .spec.triggers[].imageChangeParams.from.name | head -1)
  echo -e "\t\t\t{" >> $_IMAGE_CONFIG_JSON 
  echo -e "\t\t\t\t\"APPLICATION_NAME\": \"$_DC\"," >> $_IMAGE_CONFIG_JSON 
  echo -e "\t\t\t\t\t\"IMAGE_VERSION\": \"$_IMAGE\"," >> $_IMAGE_CONFIG_JSON 
  echo -e "\t\t\t}," >> $_IMAGE_CONFIG_JSON 
done

echo "`cat <<EOF
        ]
} 
EOF`" >> $_IMAGE_CONFIG_JSON
