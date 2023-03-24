#!/bin/bash

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
