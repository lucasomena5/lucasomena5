#!/bin/bash

APP_NAME="senhasegura-app"

# az ad app create --display-name "$APP_NAME"  

APP_ID=$(az ad app list --filter "displayName eq '$APP_NAME'" --query '[].appId' -o tsv)

# if [[ $APP_ID != " " ]];
# then 
#     echo $APP_ID
#     sleep 20
#     az ad app credential reset --id "$APP_ID" >> app-secret.json
# else 
#     echo "ERROR"
# fi 

## az ad sp list --query "[].{Name:appDisplayName, Id:appId}" --output table --all
## az ad sp list --query "[?appDisplayName=='Microsoft Graph'].appId" --output tsv --all
## az ad sp show --id 00000002-0000-0000-c000-000000000000 --query "appRoles[].{Value:value, Id:id}" --output table
## User.Read.All df021288-bdef-4463-88db-98f22de89214
## az ad sp show --id $graphId --query "oauth2Permissions[].{Value:value, Id:id}" --output table

az ad app permission add --id $APP_ID --api "00000002-0000-0000-c000-000000000000" --api-permissions "5778995a-e1bf-45b8-affa-663a9f3f4d04=Scope"

az ad app permission grant --id $APP_ID --api "00000002-0000-0000-c000-000000000000" --scope "/"
# az ad app permission admin-consent --id $APP_ID






