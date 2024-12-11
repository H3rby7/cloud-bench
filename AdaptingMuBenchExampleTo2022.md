# Adapting muBench Example for Alibaba to 2022 traces

[Original Example](./muBench/examples/README.md#alibaba-derived-applications-and-traces)

## Motivation

To generate realistic workloads for the benchmarking microservices created by muBench we should use corresponding call rates from the traces as well.

We want to use the 2022 trace data, because:

* Call rates have cycles (hourly, daily, weekly, ...) and the 2022 trace has 13 days of traces which allows us to model up to a weekly cycle.
* We need to re-create the benchmark muBench Microservices anyways, so we can extract the corresponding MS-Call data as well. (The output data provided by the original authors cannot directly be linked back)
    * can use rpcid == '0' to find the users' calls

## Changes from MS 2021 to MS 2022

First entry of 2021 MSCallGraph

id | traceid | timestamp | rpcid | um | rpctype | dm | interface | rt
--- | --- | --- | --- | --- | --- | --- | --- | ---
0 | 0b133c1915919238193454000e5d37 | 219678 | 0.1.3.1.1.1.12 | 5cca70246befb1f4c9546d2912b9419dee54439218efa55a7a2e0e26e86ad749 | mc | b1dbd3a649a3cc790fa12573c9c1aa00988e07a8818a2214208b9697238c1b11 | 0

First entry of 2022 CallGraph

timestamp |	traceid |	service |	rpc_id | rpctype | um | uminstanceid | interface | dm | dminstanceid | rt
--- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ---
115352 | T_11560863075 | S_153587416 | 0.1 | rpc | MS_58845 | MS_58845_POD_0 | xOuy6-80Vt | MS_71712 | MS_71712_POD_244 | 2.0

Dataformat changes (from 2021)

* dropped 'id'
* 'traceid' and 'timestamp' swapped column
* added 'service' after 'traceid'
* 'rpctype' and 'um' swapped column
* added 'uminstanceid' after 'um'
* added 'dm' and 'dinstanceid' after 'interface'

# Developing / Recreating

## Software Versions

Software | Version
--- | ---
Matlab | [R2024b](https://mathworks.com/help/releases/R2024b/matlab)

