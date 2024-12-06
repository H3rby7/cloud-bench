#!/bin/bash

# Script adapted from https://github.com/alibaba/clusterdata/blob/7358bbaf40778d4bd0464a64a430812088b7b74e/cluster-trace-microservices-v2021/fetchData.sh

TRACE_URL_BASE="http://aliopentrace.oss-cn-beijing.aliyuncs.com/v2021MicroservicesTraces"
WGET_OPTS="-c --retry-connrefused --tries=0 --timeout=50 --show-progress"

echo "Downloading README for quick reference"
wget ${WGET_OPTS} https://github.com/alibaba/clusterdata/raw/7358bbaf40778d4bd0464a64a430812088b7b74e/cluster-trace-microservices-v2021/README.md

mkdir -p MSCallGraph
cd MSCallGraph

# Index 0 to 144 are available...
# for((i=0;i<=144;i++));
# Detti et. al only use MSCallGraph_0
for((i=0;i<=0;i++));
do
  command="wget ${WGET_OPTS} ${TRACE_URL_BASE}/MSCallGraph/MSCallGraph_${i}.tar.gz"
  echo "Retrieving MSCallGraph Part ${i}/24..."
  ${command}
done
cd ..

# Un-comment to download
# mkdir -p MSRTQps
# cd MSRTQps

# for((i=0;i<=24;i++));
# do
#   command="wget ${WGET_OPTS} ${TRACE_URL_BASE}/MSRTQps/MSRTQps_${i}.tar.gz"
#   echo "Retrieving MSRTQps Part ${i}/24..."
#   ${command}
# done
# cd ..

echo "Finished"
exit 0
