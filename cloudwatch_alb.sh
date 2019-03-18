#!/bin/bash

while getopts n:d:m:s: OPT
do
  case ${OPT} in
    n) NAMESPACE=${OPTARG} ;;
    d) DIMENSIONS=${OPTARG} ;;
    m) METRIC=${OPTARG} ;;
    s) STATISTICS=${OPTARG} ;;
    *) exit 1 ;;
  esac
done

### example
# ./cloudwatch.sh -n AWS/[EC2,RDS] -d Name=[InstanceId,mydbinstance],Value=[instanceID,mydbinstance] -m CPUUtilization -s Maximum

aws cloudwatch get-metric-statistics --region ap-northeast-1 --period 300 \
 --namespace ${NAMESPACE} \
 --dimensions ${DIMENSIONS} \
 --metric-name ${METRIC} \
 --statistics ${STATISTICS} \
 --start-time `date --iso-8601=seconds --date '5 minutes ago'` \
 --end-time `date --iso-8601=seconds --date '0 minutes ago'` | sort -k 3,3 | tail -n -1 | awk '{print $2}'
