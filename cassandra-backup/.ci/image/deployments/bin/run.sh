#!/bin/bash

echo "run.sh"

##################################### Run Prerequisite
pip install --upgrade pip
pip install -r /tmp/src/deployments/executable/requirements.txt

##################################### Run executable file
cd /tmp/src/deployments/executable/

python $EXECUTABLE_SCRIPTS