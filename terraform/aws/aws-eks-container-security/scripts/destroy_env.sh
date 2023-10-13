#!/bin/bash

destroyEnv() {

    echo "[INFO] `date "+%Y-%m-%d %H:%M"` Running terraform init"
    terraform destroy -auto-approve

    sleep 10
   
}

removeFiles() {
    if [ -e *.tfplan ]
    then
        rm -rf *terraform.tfstate* .terraform* *.tfplan *.pem ig.yml
    fi
}

echo "[INFO] `date "+%Y-%m-%d %H:%M"` Running first function"
destroyEnv

echo "[INFO] `date "+%Y-%m-%d %H:%M"` Running second function"
removeFiles