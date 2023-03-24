#!/bin/bash

LOG=$HOME/test-hpa-log.logs

while true;
do 
  DATE_WITH_TIME=`date "+%Y-%m-%d %H:%M:%S"`
  echo "-------------------------------- $DATE_WITH_TIME --------------------------------" >> $LOG
  
  for _HPA in $(kubectl get hpa --no-headers | awk '{print $1}');
  do
    _HPA_NAME=$(kubectl get hpa $_HPA --no-headers | awk '{print $1}') >> $LOG
    _HPA_MIN=$(kubectl get hpa $_HPA --no-headers | awk '{print $4}') >> $LOG
    _HPA_CURRENT=$(kubectl get hpa $_HPA --no-headers | awk '{print $6}') >> $LOG
    _HPA_CPU=$(kubectl get hpa $_HPA --no-headers | awk '{print $3}' | cut -d '/' -f 2)
    
    if [[ $_HPA_MIN != $_HPA_CURRENT ]];
    then  
      echo -e "[INFO]\tThe current CPU utilization is $_HPA_CPU - $_HPA_NAME scaled from $_HPA_MIN to $_HPA_CURRENT at `date "+%H:%M:%S"` UTC" >> $LOG
    fi
	
  done 
  
  sleep 5
done 

DATE_WITH_TIME=`date "+%Y-%m-%d %H:%M:%S"`
echo "-------------------------------- $DATE_WITH_TIME --------------------------------" >> $LOG