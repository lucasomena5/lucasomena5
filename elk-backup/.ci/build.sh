#!/bin/bash

pushd ..

pip install -U pytest
pip install mock
pip install -r src/main/scripts/executable/requirements.txt

popd