#!/bin/bash

echo "[INFO] `date "+%Y-%m-%d %H:%M"` Running terraform plan"
terraform plan -out forgerock.tfplan 

sleep 10 

echo "[INFO] `date "+%Y-%m-%d %H:%M"` Running terraform apply"
terraform apply "forgerock.tfplan"