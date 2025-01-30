# YAMLs for Kubernetes

## Debugging File mounts

Replace a container's `command` line with a sleep statement:

    command: ["/bin/bash", "-c", "--", "while true; do sleep 30; done;"]

Exec into the container:

    kubectl --kubeconfig cloudlab_kubeconfig.yaml exec -it cloud-ee-benchmarking-<xyz> -c <container-name> -- bash
