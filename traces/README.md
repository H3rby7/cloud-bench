# Traces

Scripts and docker-compose to download the necessary traces.

Contents:

- [Traces](#traces)
  - [Alibaba Trace 2018](#alibaba-trace-2018)
    - [Download Trace Data](#download-trace-data)
    - [Short info on trace data](#short-info-on-trace-data)
  - [Alibaba Microservices Trace 2021](#alibaba-microservices-trace-2021)
    - [Download Trace Data](#download-trace-data-1)
- [Development tips](#development-tips)

## Alibaba Trace 2018

Contents of the trace with 'used by' (refering to projects in use here.)

File | Used by
--- | ---
machine_meta.tar.gz     | none (download is commented out)
container_meta.tar.gz   | none (download is commented out)
batch_task.tar.gz       | [trace-generator](./trace-generator/)
machine_usage.tar.gz    | none (download is commented out)
batch_instance.tar.gz   | [trace-generator](./trace-generator/)
container_usage.tar.gz  | none (download is commented out)

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

    docker-compose up alibaba-trace-v2018

### Short info on trace data

* Jobs consist of tasks
* tasks (batch_task.csv) can have multiple instances (batch_instances.csv)
* tasks can depend on other tasks

## Alibaba Microservices Trace 2021

Contents of the trace with 'used by' (refering to projects in use here.)

Directory | Content | Used by
--- | --- | ---
Node            |                   | none
MSResource      |                   | none
MSRTQps         | MS Return Times   | none
MSCallGraph     | MS Call traces    | Load for MS Calls, [muBench](./muBench/)

[Alibaba 2021 Microservices Trace](https://github.com/alibaba/clusterdata/tree/7358bbaf40778d4bd0464a64a430812088b7b74e/cluster-trace-microservices-v2021)

### Download Trace Data

Fetches Alibaba Cluster Trace 2018 using a docker-compose variant of the
['fetchData.sh'](https://github.com/alibaba/clusterdata/blob/7358bbaf40778d4bd0464a64a430812088b7b74e/cluster-trace-microservices-v2021/fetchData.sh)
script.

Build a minimal docker container and download the trace information.
By default will only download 'batch_xxx.tar.gz' files.

*Note: This will take a very long time as the hosting server is slow*

    docker-compose up alibaba-trace-ms-v2021

# Development tips

See full progress of docker-compose build

    docker-compose build --progress plain

Inspect logs

    docker-compose logs -f

Exec into a container

    docker-compose exec -it alibaba-trace-v2018 bash
    docker-compose exec -it alibaba-trace-ms-v2021 bash

Display file size in container (while being downloaded the files are not visible outside the container, so this can help inspect progress on the download from the outside)

    docker-compose exec -it alibaba-trace-v2018 ls -lsh
    docker-compose exec -it alibaba-trace-ms-v2021 ls -lsh
