#!/bin/bash
yum update -y
yum install git -y
# set hostname
sudo hostnamectl set-hostname "docker.cluster.local"
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

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt install docker-ce docker-ce-cli containerd.io -y
sudo usermod -aG docker $USER
newgrp docker


sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# IMAGES and Containers
sudo mkdir /docker
cd /docker
sudo git clone https://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@github.com/qsquad3/docker-files.git

# JENKINS 
cd /docker/docker-files/jenkins
sudo docker-compose up -d

# PGSQL
cd /docker/docker-files/pgsql
sudo docker-compose up -d

# APP (buid image)
cd /docker/docker-files/app
sudo docker login -u qsquad3 -p dckr_pat_c6BWxdwtDLByUnP8f8JxD76SxWU
sudo docker build -t app .
sudo docker tag app qsquad3/app
sudo docker push qsquad3/app

# Install TNS-Grafana
sudo mkdir /tns
cd /tns
sudo git clone https://github.com/grafana/tns.git
cd /tns/tns
cd production/docker-compose
sudo docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions
sudo docker-compose up -d

# somente pra saber se chegou até o final
echo "ok" > /tmp/ok.txt