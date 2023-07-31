#!/bin/bash

PROJECT_ID=$(gcloud projects list --format 'value(name)' | grep senhasegura)

gcloud iam service-accounts create sa-senhasegura \
    --description "Service Account for senhasegura" \
    --display-name "sa-senhasegura"

SERVICE_ACCOUNT=$(gcloud iam service-accounts list --filter="displayName:sa-senhasegura" --format='value(email)')

gcloud iam service-accounts keys create "sa-key.json" \
    --iam-account $SERVICE_ACCOUNT \
    --key-file-type "json" 

KEY_ID=$(cat sa-key | jq .private_key_id)

gcloud iam service-accounts keys list --iam-account $SERVICE_ACCOUNT --filter "name~$KEY_ID"

gcloud beta iam service-accounts keys get-public-key $KEY_ID \
    --iam-account="$SERVICE_ACCOUNT" \
    --output-file="sa.key"