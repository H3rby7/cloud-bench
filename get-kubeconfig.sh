#!/bin/bash

# username="USER INPUT"
read -p "Enter username: " username
# sshkeyloc="USER INPUT"
read -p "Enter location of your ssh key: " sshkeyloc
# fqdn="USER INPUT"
read -p "Enter FQDN of node-0: (e.g. apt001.apt.emulab.net)" fqdn

echo "Getting kubeconfig from ${username}@${fqdn}:/users/${username}/.kube/config"

scp -i ${sshkeyloc} ${username}@${fqdn}:/users/${username}/.kube/config config.yaml

cat config.yaml | sed -r "s/server:.*/server: https://${fqdn}:6443/" > cloudlab_kubeconfig.yaml

rm config.yaml
