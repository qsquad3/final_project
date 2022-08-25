# Final Project Quode SRE BootCamp (Squad 3)
This is a final project SRE BootCamp. 

# Squad 3 Team
- Cesar Gustavo da Silva Godinho [<p align="left"><img src="https://img.shields.io/badge/linkedin-%230077B5.svg?&style=for-the-badge&logo=linkedin&logoColor=white" /></p>](https://www.linkedin.com/in/cgsgodinho/)
- Thiago Felipe de Andrade [<p align="left"><img src="https://img.shields.io/badge/linkedin-%230077B5.svg?&style=for-the-badge&logo=linkedin&logoColor=white" /></p>](https://www.linkedin.com/in/thiago-felipe-de-andrade-932aab5/)
- Fabiano Cesar Gaspar [<p align="left"><img src="https://img.shields.io/badge/linkedin-%230077B5.svg?&style=for-the-badge&logo=linkedin&logoColor=white" /></p>](https://www.linkedin.com/in/thiago-felipe-de-andrade-932aab5/)
- Claudia Jugue [<p align="left"><img src="https://img.shields.io/badge/linkedin-%230077B5.svg?&style=for-the-badge&logo=linkedin&logoColor=white" /></p>](https://www.linkedin.com/in/claudia-jugue/)
- Gabriel Mariusso [<p align="left"><img src="https://img.shields.io/badge/linkedin-%230077B5.svg?&style=for-the-badge&logo=linkedin&logoColor=white" /></p>](https://www.linkedin.com/in/gabriel-mariusso/)

## Infraestrutura Kubernetes

A estrutura compõe-se de 3 hosts, sendo 1 MASTER e 2 WORKERS.
A implantação da estrutura é feita via Terraform, configurando automaticamente o host MASTER e efetuando JOIN dos dois hosts WORKERS.
Nesta estrutura será armazenado a aplicação Python.

![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)

## Infraestrutura Docker

A estrutura compõe-se de 1 host, sendo Docker Server.
Nesta estrutura estamos subindo as ferramentas de modo automatizado, sendo elas:
- Jenkins
- ...
## Aplicação Python

Diretório da aplicação: /app

Arquivo principal da aplicação: /app/app.py

Dockerfile da aplicação: /app/Dockerfile

Arquivo para criação da tabela do banco de dados: create_database.sql

### Instanciando a aplicação via docker-compose:

```
git clone https://github.com/phwebcloud/python_app.git
cd python_app/
docker-compose up --build -d
```

Acessar a aplicação na porta 80 do servidor

### Variáveis ambiente para conexão com banco de dados:

host = os.getenv("DB_HOST")

database = os.getenv("DB_NAME")

user = os.getenv("DB_USER")

password = os.getenv("DB_PASSWD")


Comandos:

psql -d postgres -U user -W