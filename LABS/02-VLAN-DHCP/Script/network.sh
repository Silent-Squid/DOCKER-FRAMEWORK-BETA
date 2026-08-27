#!/bin/bash
source ./lib/lib-01.sh 

#----------------------------------------------CREACIÓN DE INTEFACES DE RED ---------------------------------------

MakeCLI 1 4 DHCP4


#Servidor ...........................................
server=$(PID server)

makeifs $server server veth0
dhcp1_dev=$dev dhcp1_dev_I=$dev2 


dServer (){
    docker exec server $1
}

dServer "ip link add link $dhcp1_dev_I name "$dhcp1_dev_I.10" type vlan id 10"
dServer "ip link add link $dhcp1_dev_I name "$dhcp1_dev_I.20" type vlan id 20"

dServer "ip addr add 192.168.0.5/25 dev $dhcp1_dev_I.10"
dServer "ip addr add 192.168.0.135/25 dev $dhcp1_dev_I.20"

dServer "ip link set up $dhcp1_dev_I.10"
dServer "ip link set up $dhcp1_dev_I.20"

# ---------------------------------------------------------- REDES POR VSWITCH ---------------------------------------------------------------------- #

switch="switch-red1"
ovs-vsctl add-br $switch

PADD $switch $dhcp1_dev
ovs-vsctl set port $dhcp1_dev trunks=10,20 vlan_mode=trunk


for i in {1..4}; do
    PADD $switch ${cliente_dev[$i]}
done

for i in {1..2}; do

    ovs-vsctl set port ${cliente_dev[$i]} tag=10 vlan_mode=access
    echo vlan 10 configured in client$i
done

for i in {3..4}; do

    ovs-vsctl set port ${cliente_dev[$i]} tag=20 vlan_mode=access
    echo vlan 20 configured in client$i
done

dServer supervisorctl restart kea





