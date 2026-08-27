#!bin/bash
source ./lib/lib-01.sh 


#CAOS MUERTE Y DESTRUCCIÓN
DockerDestroy cliente1
DockerDestroy cliente2
DockerDestroy cliente3
DockerDestroy cliente4

DockerDestroy server

ovs-vsctl del-br switch-red1