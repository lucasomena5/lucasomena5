#!/bin/bash

appName="senhasegura-app-v8"

az ad app create --display-name "$appName"  

appId=$(az ad app list --filter "displayName eq '$appName'" --query '[].appId' -o tsv)

if [[ $appId != " " ]];
then 
    echo $appId
    sleep 20
    az ad app credential reset --id "$appId" >> app-secret-$appName.json
else 
    echo "ERROR"
fi 

# az ad app permission add --id $appId --api "00000002-0000-0000-c000-000000000000" --api-permissions "5778995a-e1bf-45b8-affa-663a9f3f4d04=Scope"
az ad app permission add --id $appId --api "00000003-0000-0000-c000-000000000000" --api-permissions "df021288-bdef-4463-88db-98f22de89214=Role"

sleep 60
az ad app permission admin-consent --id $appId

az ad app permission grant --id "$(az ad app list --filter "displayName eq '$appName'" --query '[].appId' -o tsv)" --api "00000003-0000-0000-c000-000000000000" --scope Role