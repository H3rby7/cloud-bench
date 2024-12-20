#!/bin/bash

# Script adapted from https://github.com/alibaba/clusterdata/blob/7358bbaf40778d4bd0464a64a430812088b7b74e/cluster-trace-v2018/fetchData.sh

TRACE_URL_BASE="http://aliopentrace.oss-cn-beijing.aliyuncs.com/v2018Traces"
WGET_OPTS="-c --retry-connrefused --tries=0 --timeout=50 --show-progress"

echo "Downloading README for quick reference"
wget ${WGET_OPTS} https://github.com/alibaba/clusterdata/raw/7358bbaf40778d4bd0464a64a430812088b7b74e/cluster-trace-v2018/trace_2018.md

echo "Downloading schema.txt for quick reference"
wget ${WGET_OPTS} https://github.com/alibaba/clusterdata/raw/7358bbaf40778d4bd0464a64a430812088b7b74e/cluster-trace-v2018/schema.txt

# Un-comment to download
# wget ${WGET_OPTS} ${TRACE_URL_BASE}/machine_meta.tar.gz
# echo "b5b1b786b22cd413a3674b8f2ebfb2f02fac991c95df537f363ef2797c8f6d55 machine_meta.tar.gz" | sha256sum -c

# Un-comment to download
# wget ${WGET_OPTS} ${TRACE_URL_BASE}/container_meta.tar.gz
# echo "febd75e693d1f208a8941395e7faa7e466e50d21c256eff12a815b7e2fa2053f container_meta.tar.gz" | sha256sum -c

wget ${WGET_OPTS} ${TRACE_URL_BASE}/batch_task.tar.gz
echo Verifying Checksum for batch_task.tar.gz
echo "7c4b32361bd1ec2083647a8f52a6854a03bc125ca5c202652316c499fbf978c6 batch_task.tar.gz" | sha256sum -c

# Un-comment to download
# wget ${WGET_OPTS} ${TRACE_URL_BASE}/machine_usage.tar.gz
# echo "3e6ee87fd204bb85b9e234c5c75a5096580fdabc8f085b224033080090753a7a machine_usage.tar.gz" | sha256sum -c

wget ${WGET_OPTS} ${TRACE_URL_BASE}/batch_instance.tar.gz
echo Verifying Checksum for batch_instance.tar.gz
echo "e73e5a9326669aa079ba20048ddd759383cabe1fe3e58620aa75bd034e2450c6 batch_instance.tar.gz" | sha256sum -c

# Un-comment to download
# wget ${WGET_OPTS} ${TRACE_URL_BASE}/container_usage.tar.gz
# echo "b4bd3b1b82f5407c1b0dd47fe736ff5152c4b016a9c30cb26f988e2d1c5e5031 container_usage.tar.gz" | sha256sum -c

echo "Finished"
exit 0
