# Combine uBench and Spar

Working with [Alibaba's cluster trace](https://github.com/alibaba/clusterdata/tree/7358bbaf40778d4bd0464a64a430812088b7b74e)
are [muBench](https://github.com/H3rby7/muBench)
and [Spar](https://github.com/H3rby7/trace-generator)

Contents:

- [Combine uBench and Spar](#combine-ubench-and-spar)
- [Tool Installation](#tool-installation)
  - [Spar - Trace Generator](#spar---trace-generator)
    - [Spar - Traces](#spar---traces)
    - [Spar - Genereting traces](#spar---genereting-traces)
  - [muBench - Demo Microservice Generator](#mubench---demo-microservice-generator)
    - [muBench and Alibaba Trace 2021](#mubench-and-alibaba-trace-2021)
- [Traces](#traces)
- [Acknowledgements](#acknowledgements)
- [Kubectl](#kubectl)

# Tool Installation

To increase adoptability all commands are using docker containers.

## Spar - Trace Generator

    docker-compose up trace-gen -d
    docker-compose exec -it trace-gen bash
    python -m spar --help

### Spar - Traces

The docker container has the original 'spar' 1-hour long trace within the directory:

    /original-spar-1h-trace

To access these from your local machine you may want to copy them into a mounted directory:

    cp -r /original-spar-1h-trace /trace/

### Spar - Genereting traces

Create an output directory:

    mkdir -p /generated/tmp

Using the original sample data:

    python -m spar /generated/tmp --trace-dir /original-spar-1h-trace

Or use your own data from the mounted directory (and specify more options)

    python -m spar /generated/tmp --trace-dir /trace --duration 0.5 --load-factor 5

The original 'spar' data only spans over one hour. 
Literature suggests that workload follows cycles, such as hours over a day and even months/seasons.

## muBench - Demo Microservice Generator

muBench generates Microservice architectures derived from the Alibaba 2021 Microservices trace.
The resulting architecture can be deployed into Kubernetes and also be called via REST, allowing to benchmark the system.

[Great docs in their own repo](./muBench/README.md)

### muBench and Alibaba Trace 2021

Their repository contains a [ZIP file](./muBench/examples/Alibaba/)
with microservices that are derived from Alibaba Traces.

Also the Matlab Code to produce the content [is available here](./muBench/examples/Alibaba/Matlab).

Start and exec into container

    docker-compose up mubench -d
    docker-compose exec -it mubench bash

Generate WorkModel

    python3 WorkModelGenerator/RunWorkModelGen.py -c WorkModelParameters.json

Generate deployment files

    python3 Deployers/K8sDeployer/RunK8sDeployer.py -c K8sParameters.json

# Traces

See [Traces](./traces/)

# Acknowledgements

This product includes software developed by University of Rome Tor Vergata and its contributors.

# Kubectl

Get the kubeconfig from the server

    sh get-kubeconfig.sh

    kubectl --kubeconfig cloudlab_kubeconfig.yaml info

    kubectl --kubeconfig cloudlab_kubeconfig.yaml create ns mubench

    kubectl --kubeconfig cloudlab_kubeconfig.yaml -nmubench get all
