#!/bin/bash

moduleDirOCP="image"
moduleDir=".."
pathEnvFileM3="${moduleDir}/src/main/scripts/config"
pathEnvFileS2I="${moduleDirOCP}/.s2i"
pathremoveEnvFile="${moduleDirOCP}/deployments/config"


mkdir -p ${moduleDirOCP}/deployments/config
mkdir -p ${moduleDirOCP}/deployments/lib
mkdir -p ${moduleDirOCP}/deployments/executable
mkdir -p ${moduleDirOCP}/deployments/batches
chmod 775 ${moduleDirOCP}/deployments/batches
cp -R ${moduleDir}/src/main/scripts/config/* ${moduleDirOCP}/deployments/config/

cp -rf ${moduleDir}/src/main/scripts/executable/* ${moduleDirOCP}/deployments/executable/

if [[ -f "${pathEnvFileM3}/environment" ]]; then
    echo $'\n' >> ${pathEnvFileS2I}/environment
    cat ${pathEnvFileM3}/environment >> ${pathEnvFileS2I}/environment
    rm -f ${pathremoveEnvFile}/environment
    rm -f ${pathremoveEnvFile}/environment_ansible
fi