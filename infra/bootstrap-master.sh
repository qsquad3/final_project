#!/bin/bash

# set hostname
sudo hostnamectl set-hostname "k8smaster.squad3.local"
sudo apt-get install apache2 -y
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

# Install Kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
# hosts para kubernets
sudo echo "10.0.3.11   k8smaster" >> /etc/hosts
sudo echo "10.0.3.12   k8worker1" >> /etc/hosts
sudo echo "10.0.3.13   k8worker2" >> /etc/hosts

sudo service apache2 start
sudo su -c "sudo kubeadm init --pod-network-cidr=10.0.0.0/16 --ignore-preflight-errors=all" root

sudo su -c "mkdir -p /root/.kube" root
sudo su -c "sudo cp -i /etc/kubernetes/admin.conf /root/.kube/config" root
sudo su -c "sudo chown $(id -u):$(id -g) /root/.kube/config" root
sudo su -c "export KUBECONFIG=/etc/kubernetes/admin.conf" root

sudo kubeadm token create --print-join-command > /var/www/html/join.txt

sudo kubeadm init --pod-network-cidr=10.0.0.0/16 --ignore-preflight-errors=all

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=/etc/kubernetes/admin.conf

cd /tmp
curl https://docs.projectcalico.org/manifests/calico.yaml -O
sudo kubectl apply -f /tmp/calico.yaml

curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

sudo helm repo add nginx-stable https://helm.nginx.com/stable
sudo helm repo update
sudo helm install ingress-nginx nginx-stable/nginx-ingress



# somente pra saber se chegou até o final
echo "ok" > /tmp/ok.txt