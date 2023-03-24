#!/bin/bash

echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] Starting prkubectless to capture LPVR queue size"

#########################################################################################################
#                                          CONFIGURE GLOBAL VARIABLES                                   #
#########################################################################################################
TIMESTAMP=`date "+%Y%m%d-%H%M%S"`
CHECK_LOG_FOLDER=$(ls /var/log/ | grep queue_size | wc -l)
#NAMESPACE=$(kubectl get ns | grep -E "preproduction|preproduction-oregon|gcpsit|gcpdev" | awk '{print $1}')
NAMESPACE="avs-68"

#########################################################################################################
#                                          CONFIGURE FOLDER LOG                                         #
#########################################################################################################
if [ $CHECK_LOG_FOLDER -eq 0 ];
then
  echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] Checking if folder exists"
  echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] Creating folder /var/log/queue_size/"
  mkdir -p /var/log/queue_size/
else
  echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] /var/log/queue_size/ is already created"
fi

#########################################################################################################
#                                          CHECKING LPVR QUEUE SIZE                                     #
#########################################################################################################
QUEUE_LOG=/var/log/queue_size/amq_queue_$TIMESTAMP.log

echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] Running kubectl proxy command in background"
kubectl proxy -p 8001 &

if [ $NAMESPACE == "avs-68" ];
then   
  echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] Checking LPVR queues from namespace: "$NAMESPACE
  
  for BROKER in $(kubectl get pods -n $NAMESPACE | grep "avs-amq" | egrep -v "deploy|drainer" | awk '{print $1}')
  do
    QUEUE_SIZE=$(curl "http://127.0.0.1:8001/api/v1/namespaces/$NAMESPACE/pods/https:$BROKER:8778/proxy/jolokia/read/org.apache.activemq:type=Broker,brokerName=$BROKER,destinationType=Queue,destinationName=push-message-ms-lpvr-mediaroom-queue/QueueSize")
    echo -ne  "$QUEUE_SIZE\n" >> $QUEUE_LOG 
  done
  
  NUMBER_BROKERS=$(kubectl get pods -n $NAMESPACE | grep "avs-amq" | egrep -v "deploy|drainer" | wc -l)
  echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] Nummber of brokers $NUMBER_BROKERS" 
  index=1
  
  echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] Checking queue size"
  for BROKER in $(kubectl get pods -n $NAMESPACE | grep "avs-amq" | egrep -v "deploy|drainer" | awk '{print $1}')
  do  
    NUMBER_MESSAGE_QUEUE=$(cat $QUEUE_LOG | grep $BROKER | grep -Po "\"value\":[0-9]" $QUEUE_LOG | sed 's/\"value\"://' | head -$index | tail -1)

    if [[ $NUMBER_MESSAGE_QUEUE -gt 20 ]];
    then 
      echo "`date "+%Y-%m-%d %H:%M:%S"` [WARNING] $NUMBER_MESSAGE_QUEUE message in the LPVR queue to be prkubectlessed for broker $BROKER"
    else 
      echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] $NUMBER_MESSAGE_QUEUE message(s) in the LPVR queue to be prkubectlessed for broker $BROKER"
    fi
		if [[ $index -le $NUMBER_BROKERS ]];
        then 
          index=$(expr $index + 1 | bc -l)
        fi 

  done 
  
  echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] LPVR queue log file can be found in $QUEUE_LOG"
  
  PROXY_PID=$(ps -ef | grep "kubectl proxy" | grep 8001 | grep -v grep | awk '{print $2}')
  echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] Killing kubectl proxy prkubectless"
  kill -9 $PROXY_PID
  
  echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] Ending prkubectless to capture LPVR queue size"

elif [ $NAMESPACE == "preproduction-oregon" ];
then 
  echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] Checking LPVR queues from namespace: "$NAMESPACE
  
  for BROKER in $(kubectl get pods -n $NAMESPACE | grep "avs-amq" | egrep -v "deploy|drainer" | awk '{print $1}')
  do
    QUEUE_SIZE=$(curl "http://127.0.0.1:8001/api/v1/namespaces/$NAMESPACE/pods/https:$BROKER:8778/proxy/jolokia/read/org.apache.activemq:type=Broker,brokerName=$BROKER,destinationType=Queue,destinationName=push-message-ms-lpvr-mediaroom-queue/QueueSize")
    echo -ne  "$QUEUE_SIZE\n" >> $QUEUE_LOG 
  done
  
  NUMBER_BROKERS=$(kubectl get pods -n $NAMESPACE | grep "avs-amq" | egrep -v "deploy|drainer" | wc -l)
  echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] Nummber of brokers $NUMBER_BROKERS" 
  index=1
  
  echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] Checking queue size"
  for BROKER in $(kubectl get pods -n $NAMESPACE | grep "avs-amq" | egrep -v "deploy|drainer" | awk '{print $1}')
  do  
    NUMBER_MESSAGE_QUEUE=$(cat $QUEUE_LOG | grep $BROKER | grep -Po "\"value\":[0-9]" $QUEUE_LOG | sed 's/\"value\"://' | head -$index | tail -1)

    if [[ $NUMBER_MESSAGE_QUEUE -gt 0 ]];
    then 
      echo "`date "+%Y-%m-%d %H:%M:%S"` [WARNING] $NUMBER_MESSAGE_QUEUE message(s) on the queue to be prkubectlessed in broker $BROKER"
    else 
      echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] There is $NUMBER_MESSAGE_QUEUE message on the queue to be prkubectlessed in broker $BROKER"
    fi

        if [[ $index -le $NUMBER_BROKERS ]];
        then 
          index=$(expr $index + 1 | bc -l)
        fi 

  done 
  
  echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] LPVR queue log file can be found in $QUEUE_LOG"
  
  PROXY_PID=$(ps -ef | grep "kubectl proxy" | grep 8001 | grep -v grep | awk '{print $2}')
  echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] Killing kubectl proxy prkubectless"
  kill -9 $PROXY_PID
  
  echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] Ending prkubectless to capture LPVR queue size"
elif [ $NAMESPACE == "gcpsit" ];
then 
  echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] Checking LPVR queues from namespace: "$NAMESPACE
  
  for BROKER in $(kubectl get pods -n $NAMESPACE | grep "avs-amq" | egrep -v "deploy|drainer" | awk '{print $1}')
  do
    QUEUE_SIZE=$(curl "http://127.0.0.1:8001/api/v1/namespaces/$NAMESPACE/pods/https:$BROKER:8778/proxy/jolokia/read/org.apache.activemq:type=Broker,brokerName=$BROKER,destinationType=Queue,destinationName=push-message-ms-lpvr-mediaroom-queue/QueueSize")
    echo -ne  "$QUEUE_SIZE\n" >> $QUEUE_LOG 
  done
  
  NUMBER_BROKERS=$(kubectl get pods -n $NAMESPACE | grep "avs-amq" | egrep -v "deploy|drainer" | wc -l)
  echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] Nummber of brokers $NUMBER_BROKERS" 
  index=1
  
  echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] Checking queue size"
  for BROKER in $(kubectl get pods -n $NAMESPACE | grep "avs-amq" | egrep -v "deploy|drainer" | awk '{print $1}')
  do  
    NUMBER_MESSAGE_QUEUE=$(cat $QUEUE_LOG | grep $BROKER | grep -Po "\"value\":[0-9]" $QUEUE_LOG | sed 's/\"value\"://' | head -$index | tail -1)

    if [[ $NUMBER_MESSAGE_QUEUE -gt 0 ]];
    then 
      echo "`date "+%Y-%m-%d %H:%M:%S"` [WARNING] $NUMBER_MESSAGE_QUEUE message(s) on the queue to be prkubectlessed in broker $BROKER"
    else 
      echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] There is $NUMBER_MESSAGE_QUEUE message on the queue to be prkubectlessed in broker $BROKER"
    fi

        if [[ $index -le $NUMBER_BROKERS ]];
        then 
          index=$(expr $index + 1 | bc -l)
        fi 

  done 
  
  echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] LPVR queue log file can be found in $QUEUE_LOG"
  
  PROXY_PID=$(ps -ef | grep "kubectl proxy" | grep 8001 | grep -v grep | awk '{print $2}')
  echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] Killing kubectl proxy prkubectless"
  kill -9 $PROXY_PID
  
  echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] Ending prkubectless to capture LPVR queue size"
elif [ $NAMESPACE == "gcpdev" ];
then
  echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] Checking LPVR queues from namespace: "$NAMESPACE
  for BROKER in $(kubectl get pods -n $NAMESPACE | grep "avs-amq" | egrep -v "deploy|drainer" | awk '{print $1}')
  do
    QUEUE_SIZE=$(curl "http://127.0.0.1:8001/api/v1/namespaces/$NAMESPACE/pods/https:$BROKER:8778/proxy/jolokia/read/org.apache.activemq:type=Broker,brokerName=$BROKER,destinationType=Queue,destinationName=push-message-ms-lpvr-mediaroom-queue/QueueSize")
    echo -ne  "$QUEUE_SIZE\n" >> $QUEUE_LOG 
  done
  
  NUMBER_BROKERS=$(kubectl get pods -n $NAMESPACE | grep "avs-amq" | egrep -v "deploy|drainer" | wc -l)
  echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] Nummber of brokers $NUMBER_BROKERS" 
  index=1
  
  echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] Checking queue size"
  for BROKER in $(kubectl get pods -n $NAMESPACE | grep "avs-amq" | egrep -v "deploy|drainer" | awk '{print $1}')
  do  
    NUMBER_MESSAGE_QUEUE=$(cat $QUEUE_LOG | grep $BROKER | grep -Po "\"value\":[0-9]" $QUEUE_LOG | sed 's/\"value\"://' | head -$index | tail -1)

    if [[ $NUMBER_MESSAGE_QUEUE -gt 0 ]];
    then 
      echo "`date "+%Y-%m-%d %H:%M:%S"` [WARNING] $NUMBER_MESSAGE_QUEUE message(s) on the queue to be prkubectlessed in broker $BROKER"
    else 
      echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] There is $NUMBER_MESSAGE_QUEUE message on the queue to be prkubectlessed in broker $BROKER"
    fi

        if [[ $index -le $NUMBER_BROKERS ]];
        then 
          index=$(expr $index + 1 | bc -l)
        fi 

  done 
  
  echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] LPVR queue log file can be found in $QUEUE_LOG"
  
  PROXY_PID=$(ps -ef | grep "kubectl proxy" | grep 8001 | grep -v grep | awk '{print $2}')
  echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] Killing kubectl proxy prkubectless"
  kill -9 $PROXY_PID
  
  echo "`date "+%Y-%m-%d %H:%M:%S"` [INFO] Ending prkubectless to capture LPVR queue size"
else 
  echo "`date "+%Y-%m-%d %H:%M:%S"` [WARNING] No namespace found, check if the namespace exists."
fi
