#!/bin/bash
#
# Adicionar rota das subnets da stack lms para acesso via SSH nas instancias EC2 ou para acesso ao banco de dados.
#
# ./route-access-lms.sh [aws-user-profile-name] [environment] [username] [destination-ip || rm]
# aws-user-profile-name: nome do profile do usuario com permissao na conta (arquivo ~/.aws/credentials)
# environment: Informar se o ambiente é de dev ou prod
# destination-ip: ip que será adicionado ou removido, caso não seja informado será recuperado o ip atual
# rm: Inserindo o rm no lugar do ip, o script entendera que sera realizado somente a remocao do ip referente ao usuario informado

current_ip=`curl -s http://whatismyip.akamai.com/`
profile=${1:-default}
environment=${2:-dev}
username=${3,,}
destination=${4:-$current_ip}
base_cmd="aws --region sa-east-1 --profile $profile"

if [ -z $username ] ; then echo "Usuario nao informado" && exit 0;fi;

 if [ $environment == "prod" ] ; then
     gateway_id=igw-0cd8e8440674b1c0f
     route_id_1a=rtb-04578b39756730a7e
     ec2_sg_id=sg-01d95d61224b52def
     db_port=5432
     echo "Aplicando mudanças em Prod"
 fi

exit 0