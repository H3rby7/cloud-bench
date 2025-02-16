# Cloud Bench

Working with [Alibaba's cluster trace](https://github.com/alibaba/clusterdata/tree/7358bbaf40778d4bd0464a64a430812088b7b74e)
are [muBench](https://github.com/H3rby7/muBench)

Contents:

- [Cloud Bench](#cloud-bench)
- [Kubectl](#kubectl)
- [Acknowledgements](#acknowledgements)

# Kubectl

Get the kubeconfig from [a cloudlab node](https://www.cloudlab.us/)

    sh get-kubeconfig.sh
    # Piped shortcut
    #      the SSH command copied from cloudlab web                                                                your ssh key location
    echo ssh user@inst001.some.cloudlab.domain | awk -F ' ' '{print $2}' | awk -F '@' '{print $1}{print $2}{print "cloudlab"}' | sh get-kubeconfig.sh

Get public IP address for nginx

    kubectl --kubeconfig cloudlab_kubeconfig.yaml -nnginx get svc nginx-ingress-nginx-controller | awk -F ' ' '{print $4}'

Append `/grafana` or `/prometheus` to the public IP address to access the related services.
They are protected by basic auth. The credentials can be found in the experiment manifest profile instructions.

# Acknowledgements

This product includes software developed by University of Rome Tor Vergata and its contributors.
