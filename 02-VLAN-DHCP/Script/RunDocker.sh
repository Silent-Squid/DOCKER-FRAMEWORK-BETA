#!/bin/bash
source ./lib/lib-01.sh 


#$1 = IMAGEN DEL SERVIDOR CORRESPONDIENTE A DHCP-SERVER
#$2 = IMAGEN DEL CLIENTE CORRESPONDIENTE A DHCP-CLIENT

#RUN SERVER 

echo Launching Server ----- image $1
docker run -it -d --network Internet --name server -p 9991:9991 --cap-add=NET_ADMIN $1

RunDocker cliente1 $2; 
RunDocker cliente2 $2; 
RunDocker cliente3 $2; 
RunDocker cliente4 $2; 

bash network.sh



