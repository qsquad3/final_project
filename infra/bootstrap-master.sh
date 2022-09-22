#!/bin/bash

# set hostname
sudo hostnamectl set-hostname "k8smaster.cluster.local"
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
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system

# Install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt install docker-ce docker-ce-cli containerd.io -y
newgrp docker
sudo usermod -aG docker ubuntu
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose


# Install Kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
# hosts para kubernetes
sudo echo "10.0.3.11   k8smaster    k8smaster.cluster.local" >> /etc/hosts
sudo echo "10.0.3.12   k8worker1    k8worker1.cluster.local" >> /etc/hosts
sudo echo "10.0.3.13   k8worker2    k8worker2.cluster.local" >> /etc/hosts

sudo service apache2 start
sudo su -c "sudo kubeadm init --pod-network-cidr=10.48.0.0/16 --service-cidr=10.49.0.0/16 --control-plane-endpoint `curl ifconfig.me`" root

sudo su -c "mkdir -p /root/.kube" root
sudo su -c "sudo cp -i /etc/kubernetes/admin.conf /root/.kube/config" root
sudo su -c "sudo chown $(id -u):$(id -g) /root/.kube/config" root
sudo su -c "export KUBECONFIG=/etc/kubernetes/admin.conf" root

sudo kubeadm token create --print-join-command > /var/www/html/join.txt
cd /var/www/html
sudo sed -i '$s/$/ --ignore-preflight-errors=all/' join.txt

sudo kubeadm init --pod-network-cidr=10.48.0.0/16 --service-cidr=10.49.0.0/16 --control-plane-endpoint `curl ifconfig.me`

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=/etc/kubernetes/admin.conf

# Install Helm
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

# Install Calico cni
sudo helm repo add projectcalico https://projectcalico.docs.tigera.io/charts
sudo kubectl create namespace tigera-operator
sudo helm install calico projectcalico/tigera-operator --version v3.24.1 --namespace tigera-operator

# Install kubernetes-dashboard 
sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml

# Install DataDog
# Ubuntu Agent
DD_AGENT_MAJOR_VERSION=7 DD_API_KEY=d02690e83d0162e671b9ff6436597738 DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"
# Kubernetes Agent
sudo helm repo add datadog https://helm.datadoghq.com
sudo helm repo update
cd /deploys/docker-files/kubernetes
sudo helm install datadog-k8s -f datadog-values.yaml  datadog/datadog --set targetSystem=linux --set clusterAgent.replicas=2 --set clusterAgent.createPodDisruptionBudget=true

# Deploy kubernetes files
sudo kubectl create namespace app
sudo kubectl create namespace app-dev
sudo mkdir /deploys
cd /deploys
sudo git clone https://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@github.com/qsquad3/docker-files.git
cd docker-files/kubernetes
sudo kubectl apply -f app-service.yaml
sudo kubectl apply -f app-deploy.yaml
sudo kubectl apply -f app-service-dev.yaml
sudo kubectl apply -f app-deploy-dev.yaml
#sudo kubectl apply -f app-replicaset.yaml

# Sinalizando que chegou ao final do bootstrap
echo "ok" > /tmp/ok.txt

