#!/bin/bash

LOCUST_HOST=$1
LOCUST_DIR=$2
LOCUST_USERS=$3
LOCUST_SPAWN_RATE=$4
LOCUST_RUN_TIME=$5

locust --host $LOCUST_HOST \
  --locustfile $LOCUST_DIR/locustfile.py \
  --users $LOCUST_USERS \
  --spawn-rate $LOCUST_SPAWN_RATE \
  --run-time $LOCUST_RUN_TIME