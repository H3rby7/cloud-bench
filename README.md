# Combine uBench and Spar

Working with [Alibaba's cluster trace](https://github.com/alibaba/clusterdata/tree/7358bbaf40778d4bd0464a64a430812088b7b74e)
are [muBench](https://github.com/H3rby7/muBench)
and [Spar](https://github.com/H3rby7/trace-generator)

# Installation

To increase adoptability all commands are using docker ocntainers.

## Alibaba Trace

[Alibaba 2018 Cluster Trace](https://github.com/alibaba/clusterdata/blob/7358bbaf40778d4bd0464a64a430812088b7b74e/cluster-trace-v2018/trace_2018.md)

Fetches Alibaba Cluster Trace 2018 using a docker-compose variant of the
['fetchData.sh'](https://github.com/alibaba/clusterdata/blob/7358bbaf40778d4bd0464a64a430812088b7b74e/cluster-trace-v2018/fetchData.sh)
script.

Checksum validation against the checksums provided in 
['trace_2018.md'](https://github.com/alibaba/clusterdata/blob/7358bbaf40778d4bd0464a64a430812088b7b74e/cluster-trace-v2018/trace_2018.md).

    # Build a minimal docker container to download the trace
    docker-compose -f docker-compose-trace.yml up -d

    # Inspect progress, if interested
    docker-compose -f docker-compose-trace.yml logs -f

    # Exec into ocntainer
    docker-compose -f docker-compose-trace.yml exec -it alibaba-trace bash

## Spar - Trace Generator

    git clone https://github.com/H3rby7/trace-generator
    docker-compose up -d
    docker-compose exec trace-gen bash

### Spar - Installation

You can use the pre-packaged version via `pip` or run from the sources.

#### Spar - Installing via pip

    pip3 install spar
    spar --help

#### Spar - Running from source

    pip install .
    python -m spar --help

### Spar - Genereting traces

*Note: If you installed the tool using `pip` you can omit the `python -m` prefixes of each command.*

    python -m spar generated --duration 0.05
