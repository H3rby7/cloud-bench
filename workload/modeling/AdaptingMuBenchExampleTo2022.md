# Adapting muBench Example for Alibaba to 2022 traces

[Original Example](./muBench/examples/README.md#alibaba-derived-applications-and-traces)

## Motivation

To generate realistic workloads for the benchmarking microservices created by muBench we should use corresponding call rates from the traces as well.

We want to use the 2022 trace data, because:

* Call rates have cycles (hourly, daily, weekly, ...) and the 2022 trace has 13 days of traces which allows us to model up to a weekly cycle.
* We need to re-create the benchmark muBench Microservices anyways, so we can extract the corresponding MS-Call data as well. (The output data provided by the original authors cannot directly be linked back)
    * can use rpcid == '0' to find the users' calls

# Developing / Recreating

## Software Versions

Software | Version
--- | ---
Matlab | [R2024b](https://mathworks.com/help/releases/R2024b/matlab)

