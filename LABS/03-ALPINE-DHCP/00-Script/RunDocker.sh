#!/bin/bash
source ./lib/lib-01.sh 

#BIENVENIDO AL SCRIPT RunDocker.sh. Este script se utiliza para diseñar y lanzar la topología de docker, no la de la red. 


#$1 = IMAGEN DEL SERVIDOR CORRESPONDIENTE A DHCP-SERVER
#$2 = IMAGEN DEL CLIENTE CORRESPONDIENTE A DHCP-CLIENT

#RUN SERVER 

echo Launching Server ----- image $1
docker run -it -d --name server --network Internet --cap-add=NET_ADMIN -p 9988:9988 $1

#Corriendo los clientes

for i in {1..10}; do

    RunDocker cliente$i $2;

done

bash network.sh
