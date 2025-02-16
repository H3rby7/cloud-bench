# Traces

Scripts and docker-compose to download the necessary traces.

Contents:

- [Traces](#traces)
- [Alibaba Traces](#alibaba-traces)
  - [Alibaba Microservices Trace 2021](#alibaba-microservices-trace-2021)
    - [Download Alibaba Trace Data MS 2021](#download-alibaba-trace-data-ms-2021)
    - [Interseting findings](#interseting-findings)
  - [Alibaba Microservices Trace 2022](#alibaba-microservices-trace-2022)
    - [Download Alibaba Trace Data MS 2022](#download-alibaba-trace-data-ms-2022)
- [Development tips](#development-tips)

# Alibaba Traces

Alibaba Cluster Traces Repository on 
[Github@7358bbaf40778d4bd0464a64a430812088b7b74e](https://github.com/alibaba/clusterdata/blob/7358bbaf40778d4bd0464a64a430812088b7b74e).

## Alibaba Microservices Trace 2021

Contents of the trace with 'used by' (refering to projects in use here.)

Directory | Content | Used by
--- | --- | ---
Node            |                   | none
MSResource      |                   | none
MSRTQps         | MS Return Times   | none
MSCallGraph     | MS Call traces    | Load for MS Calls, [muBench](./muBench/)

[Alibaba 2021 Microservices Trace](https://github.com/alibaba/clusterdata/tree/7358bbaf40778d4bd0464a64a430812088b7b74e/cluster-trace-microservices-v2021)

### Download Alibaba Trace Data MS 2021

Fetches Alibaba Cluster Trace 2021 using a docker-compose variant of the
['fetchData.sh'](https://github.com/alibaba/clusterdata/blob/7358bbaf40778d4bd0464a64a430812088b7b74e/cluster-trace-microservices-v2021/fetchData.sh)
script.

Build a minimal docker container and download the trace information.
By default will only download 'MSCallGraph' dir.

*Note: This will take a very long time as the data is large*

    docker-compose up alibaba-trace-ms-v2021

### Interseting findings

Traces may be recorded doubled. Example: 

in `MSCallGraph_0.csv` the traces `22004` and `22005` of trace_id `0b13398a15919237330738000edeb5` describe the same call exactly.

## Alibaba Microservices Trace 2022

Contents of the trace with 'used by' (refering to projects in use here.)

Directory | Content | Used by
--- | --- | ---
Node            |                   | none
MSResource      |                   | none
MSRTQps         | MS Return Times   | none
MSCallGraph     | MS Call traces    | Load for MS Calls, [muBench](./muBench/)

[Alibaba 2022 Microservices Trace](https://github.com/alibaba/clusterdata/tree/7358bbaf40778d4bd0464a64a430812088b7b74e/cluster-trace-microservices-v2022)

### Download Alibaba Trace Data MS 2022

Fetches Alibaba Cluster Trace 2022 using a docker-compose variant of the
['fetchData.sh'](https://github.com/alibaba/clusterdata/blob/7358bbaf40778d4bd0464a64a430812088b7b74e/cluster-trace-microservices-v2022/fetchData.sh)
script.

Build a minimal docker container and download the trace information.
By default will only download 'CallGraph' dir.

*Note: This will take a very long time as the data is large*

    docker-compose up alibaba-trace-ms-v2022

# Development tips

Using only subsets of files 

(e.g. only first 100K lines of a csv)

    head -n 100000 MSCallGraph_0.csv > MSCallGraph_test.csv

Start lates by adding header row and then skip

    head -n 1 MSCallGraph_0.csv > MSCallGraph_test.csv
    head -n 200000 MSCallGraph_0.csv | tail -n 100000 >> MSCallGraph_test.csv

See full progress of docker-compose build

    docker-compose build --progress plain

Inspect logs

    docker-compose logs -f

Exec into a container

    docker-compose exec -it alibaba-trace-ms-v2021 bash
    docker-compose exec -it alibaba-trace-ms-v2022 bash

Display file size in container (while being downloaded the files are not visible outside the container, so this can help inspect progress on the download from the outside)

    docker-compose exec -it alibaba-trace-ms-v2021 ls -lsh
    docker-compose exec -it alibaba-trace-ms-v2022 ls -lsh
