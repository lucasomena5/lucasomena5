# graphId=$(az ad sp list --query "[?appDisplayName=='Microsoft Graph'].appId" --output tsv --all)
# az ad sp show --id "00000003-0000-0000-c000-000000000000" --query "appRoles[].{Value:value, Id:id}" --output table
# User.Read.All df021288-bdef-4463-88db-98f22de89214
# az ad sp show --id $graphId --query "oauth2Permissions[].{Value:value, Id:id}" --output table

# az ad sp list --query "[].{Name:appDisplayName, Id:appId}" --output table --all