#!/bin/bash

FILE_NAME="sa-senhasegura-key.json"
PROJECT_ID=$(gcloud projects list --format 'value(projectId)' | grep $1)

if [[ $PROJECT_ID != " " ]] 
then
    echo "[INFO] `date "+%Y-%m-%d %H:%M"` Google PROJECT_ID: $PROJECT_ID"
    gcloud config set project $PROJECT_ID --quiet
else
    echo "[ERROR] `date "+%Y-%m-%d %H:%M"` Google PROJECT_ID not found."
fi

#
# GCLOUD SERVICE ACCOUNT
#
gcloud iam service-accounts create sa-senhasegura \
    --description "Service Account for senhasegura" \
    --display-name "sa-senhasegura" \
    --quiet

SERVICE_ACCOUNT=$(gcloud iam service-accounts list --filter="displayName:sa-senhasegura" --format='value(email)')

if [[ $SERVICE_ACCOUNT != " " ]]
then
    echo "[INFO] `date "+%Y-%m-%d %H:%M"` Google Service Account $SERVICE_ACCOUNT has been created."
else 
    echo "[ERROR] `date "+%Y-%m-%d %H:%M"` Google Service Account has not been created properly."
fi 

#
# SERVICE ACCOUNT KEY
#
gcloud iam service-accounts keys create "$FILE_NAME" \
    --iam-account $SERVICE_ACCOUNT \
    --key-file-type "json" \
    --quiet

KEY_ID=$(cat $FILE_NAME | jq .private_key_id)

gcloud iam service-accounts keys list --iam-account $SERVICE_ACCOUNT --filter "name~$KEY_ID"

#
# BINDING ROLE OWNER 
#
MEMBER="serviceAccount:$SERVICE_ACCOUNT"
ROLE="roles/owner"

gcloud iam service-accounts add-iam-policy-binding "$SERVICE_ACCOUNT" \
  --member="$MEMBER" \
  --role="$ROLE" \
  --project="$PROJECT_ID" \
  --quiet

ROLE_BINDING=$(gcloud iam service-accounts get-iam-policy "$SERVICE_ACCOUNT" --project="$PROJECT_ID" --format="value(bindings.role)")

if [[ $ROLE_BINDING != " " ]];
then 
    echo "[INFO] `date "+%Y-%m-%d %H:%M"` Role $ROLE_BINDING has been bound successfully."
else 
    echo "[ERROR] `date "+%Y-%m-%d %H:%M"` Role binding has failed."
fi

#
# DOWNLOAD KEY THROUGH GCLOUD COMMAND
#
#gcloud cloud-shell scp cloudshell:~/$FILE_NAME localhost:~$FILE_NAME
