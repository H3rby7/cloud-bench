#!/bin/bash

# Script adapted from https://github.com/alibaba/clusterdata/blob/7358bbaf40778d4bd0464a64a430812088b7b74e/cluster-trace-microservices-v2022/fetchData.sh

TRACE_URL_BASE="https://aliopentrace.oss-cn-beijing.aliyuncs.com/v2022MicroservicesTraces"
WGET_OPTS="-c --retry-connrefused --tries=0 --timeout=50 --show-progress"

echo "Downloading README for quick reference"
wget ${WGET_OPTS} https://github.com/alibaba/clusterdata/raw/7358bbaf40778d4bd0464a64a430812088b7b74e/cluster-trace-microservices-v2022/README.md

trace_types=(
  # "NodeMetrics"
  # "MSMetrics"
  # "MSRTMCR"
  "CallGraph"
)

#!/bin/bash
prepare_dir() {
  for t in ${trace_types[@]}; do
    mkdir -p ${t}
  done
}

# $1 = start_day, $2 = end_day, $3 = start_hour, $4 = end_hour
fetch_data() {
    declare -a remote_paths=(
        "CallGraph/CallGraph"
        "MSMetricsUpdate/MSMetricsUpdate"
        "NodeMetricsUpdate/NodeMetricsUpdate"
        "MCRRTUpdate/MCRRTUpdate"
    )
    declare -a ratios=(3 30 720 3)
    start_minute=$(($1 * 24 * 60 + $3 * 60))
    end_minute=$(($2 * 24 * 60 + $4 * 60))
    echo ""
    echo ""
    echo "Getting traces from minute ${start_minute} to ${end_minute} ..."
    echo ""
    echo ""
    for i in ${!trace_types[@]}; do
        start_idx=$(($start_minute / ${ratios[$i]}))
        end_idx=$(($end_minute / ${ratios[$i]} - 1))
        if [[ $i == 2 && $(($end_minute % ${ratios[$i]})) != 0 ]]; then
            end_idx=$(($end_idx + 1))
        fi
        for idx in $(seq $start_idx $end_idx); do
            dir_name="${trace_types[$i]}"
            file_name="${trace_types[$i]}_${idx}.tar.gz"
            file_path="${dir_name}/${file_name}"
            remote_path="${remote_paths[$i]}_${idx}.tar.gz"
            url="${TRACE_URL_BASE}/${remote_path}"
            command="wget ${WGET_OPTS} -O ${file_path} ${url}"
            $command
        done
    done
}

for ARGUMENT in "$@"; do
    KEY=$(echo $ARGUMENT | cut -f1 -d=)

    KEY_LENGTH=${#KEY}
    VALUE="${ARGUMENT:$KEY_LENGTH+1}"

    export "$KEY"="$VALUE"
done
start_day=$(expr $(echo $start_date | cut -f1 -dd) + 0)
start_hour=$(expr $(echo $start_date | cut -f2 -dd) + 0)
end_day=$(expr $(echo $end_date | cut -f1 -dd) + 0)
end_hour=$(expr $(echo $end_date | cut -f2 -dd) + 0)
prepare_dir
fetch_data $start_day $end_day $start_hour $end_hour

echo "Finished"
exit 0
