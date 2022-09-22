# INFRAESTRUTURA APLICAÇÃO QUODE

Esta foi a arquitetura que utilizamos para sustentar a aplicação python Flask, do Projeto Final - SRE Bootcamp da Quode.

## Configurações para subir a Stack

Para subir a estrutura completa basta seguir os passos abaixo:

```
git clone https://github.com/qsquad3/final_project.git
```

:red_circle: ***Você precisa criar um arquivo chamado secrets.tf com suas credencias AWS conforme abaixo***
```
cd final_project/infra/terraform
vim secrets.tf
```

```
variable "accesskey" {
  description = "AWS Access Key"
  default     = "minha-access-key"
  type        = string
}

variable "secretkey" {
  description = "AWS Secret Key"
  default     = "minha-secret-key"
  type        = string
}

variable "ssh_keypair" {
  description = "SSH keypair to use for EC2 instance"
  default     = "nome-chave-ssh"
  type        = string
}
```

:red_circle: ***Você precisa criar, manualmente, um bucket S3 e adicionar o seu  nome no arquivo "providers.tf"***


## Subindo a Stack

```
$ cd final_project/infra/terraform
$ terraform init
$ terraform apply
```

## Infraestrutura Kubernetes

A estrutura compõe-se de 3 hosts, sendo 1 MASTER e 2 WORKERS.
A implantação da estrutura é feita via Terraform, configurando automaticamente o host MASTER e efetuando JOIN dos dois hosts WORKERS.
Nesta estrutura será armazenado a aplicação Python.

- ISTIO
- Kiali (precisa expor a porta 20001 no kubernetes)
- DataDog (Cloud Version)

![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Shell Script](https://img.shields.io/badge/shell_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)

## Infraestrutura Docker

A estrutura compõe-se de 1 host, sendo Docker Server.
Nesta estrutura estamos subindo as ferramentas de modo automatizado, sendo elas:
- Jenkins (ippublico-instancia-docker:8084)
- Grafana/Prometheus/Loki/Tempo (ippublico-instancia-docker:3000)
- Adminer (Adminstração PGSQL - Porta 8181)

![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Shell Script](https://img.shields.io/badge/shell_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)

![Jenkins](https://img.shields.io/badge/jenkins-%232C5263.svg?style=for-the-badge&logo=jenkins&logoColor=white)

## Aplicação Python

![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)

- O build da imagem da aplicação é feita via CICD GitHub Action após um push no repositório "final-project-application"
- Acesso aplicação (ippublico-instancia-kubernetes:8500)

