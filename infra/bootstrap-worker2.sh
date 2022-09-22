#!/bin/bash

# set hostname
sudo hostnamectl set-hostname "k8worker2.cluster.local"
sudo install curl -y

# Disable swap & add kernel settings
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

# Install docker
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update -y
sudo apt install -y containerd.io
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd

# hosts para kubernets
sudo echo "10.0.3.11   k8smaster    k8smaster.cluster.local" >> /etc/hosts
sudo echo "10.0.3.12   k8worker1    k8worker1.cluster.local" >> /etc/hosts
sudo echo "10.0.3.13   k8worker2    k8worker2.cluster.local" >> /etc/hosts

# Install Kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sleep 60
sudo curl http://10.0.3.11/join.txt | bash

#Install Datadog
# Ubuntu Agent
DD_AGENT_MAJOR_VERSION=7 DD_API_KEY=d02690e83d0162e671b9ff6436597738 DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"

# Sinalizando que chegou ao final do bootstrap
echo "ok" > /tmp/ok.txt