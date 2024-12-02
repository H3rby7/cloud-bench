# Combine uBench and Spar

Working with [Alibaba's cluster trace](https://github.com/alibaba/clusterdata/tree/7358bbaf40778d4bd0464a64a430812088b7b74e)
are [muBench](https://github.com/H3rby7/muBench)
and [Spar](https://github.com/H3rby7/trace-generator)

# Installation

To increase adoptability all commands are using docker containers.

## Alibaba Trace 2018

Contents of the trace with 'used by' (refering to projects in use here.)

File | Used by
--- | ---
machine_meta.tar.gz     | none
container_meta.tar.gz   | none
batch_task.tar.gz       | [trace-generator](./trace-generator/)
machine_usage.tar.gz    | none
batch_instance.tar.gz   | [trace-generator](./trace-generator/)
container_usage.tar.gz  | none

[Alibaba 2018 Cluster Trace](https://github.com/alibaba/clusterdata/blob/7358bbaf40778d4bd0464a64a430812088b7b74e/cluster-trace-v2018/trace_2018.md)

### Download Trace Data

Fetches Alibaba Cluster Trace 2018 using a docker-compose variant of the
['fetchData.sh'](https://github.com/alibaba/clusterdata/blob/7358bbaf40778d4bd0464a64a430812088b7b74e/cluster-trace-v2018/fetchData.sh)
script.

Checksum validation against the checksums provided in 
['trace_2018.md'](https://github.com/alibaba/clusterdata/blob/7358bbaf40778d4bd0464a64a430812088b7b74e/cluster-trace-v2018/trace_2018.md).

Build a minimal docker container and download the trace information.
By default will only download 'batch_xxx.tar.gz' files.

*Note: This will take a very long time as the hosting server is slow*

    docker-compose -f docker-compose-trace.yml up -d

Inspect progress, if interested

    docker-compose -f docker-compose-trace.yml exec -it alibaba-trace ls -lsh
    or
    docker-compose -f docker-compose-trace.yml logs -f

Exec into ocntainer

    docker-compose -f docker-compose-trace.yml exec -it alibaba-trace bash

### Short info on trace data

* Jobs consist of tasks
* tasks (batch_task.csv) can have multiple instances (batch_instances.csv)
* tasks can depend on other tasks

## Spar - Trace Generator

    docker-compose up -d
    docker-compose exec trace-gen bash

### Spar - Installation

Pre-packaged version will not work as the tool requires exact dependency versions.

TODO: Provide actual sample data.

    pip install -r requirements.txt
    python -m spar --help

### Spar - Genereting traces

*Note: If you installed the tool using `pip` you can omit the `python -m` prefixes of each command.*

    mkdir -p /generated/tmp
    python -m spar /generated/tmp --trace-dir /trace --duration 0.5 --load-factor 5
