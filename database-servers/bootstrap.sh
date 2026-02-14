#/bin/bash

dnf install ansible -y
ansible-pull -U https://github.com/SRINUNAIK208/ansible-roboshop-roles.git -e component=$1 main.yaml