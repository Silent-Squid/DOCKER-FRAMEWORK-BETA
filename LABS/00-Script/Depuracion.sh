#!bin/bash
source ./lib/lib-01.sh 


#CAOS MUERTE Y DESTRUCCIÓN

for i in {1..6}; do
    DockerDestroy cliente$i
done

DockerDestroy server

ovs-vsctl del-br switch-red1