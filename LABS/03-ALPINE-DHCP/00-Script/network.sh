#!/bin/bash
source ./lib/lib-01.sh 




#Bienvenido al script network.sh Aquí se crean y declaran las interfaces de los contenedores sus ip configuraciones especiales y conexión a ovs

#----------------------------------------------CREACIÓN DE INTEFACES DE RED ---------------------------------------

MakeCLI 1 10 #192.168.0. 9 /25

# -------------------------------------------------- SERVER -----------------------------------------------------------
server=$(PID server)
makeifs $server server dev1
server_dev="$dev" server_dev2="$dev2"

DOXE server "ip link add link $server_dev2 name $server_dev2.10 type vlan id 10"
DOXE server "ip addr add 192.168.0.5/25 dev $server_dev2.10"
DOXE server "ip link set up dev $server_dev2.10"

echo Server vlan creada $server_dev2.10


DOXE server "ip link add link $server_dev2 name $server_dev2.20 type vlan  id 20" 
DOXE server "ip addr add 192.168.0.135/25 dev $server_dev2.20"
DOXE server "ip link set up dev $server_dev2.20"

echo Server vlan creada $server_dev2.20


DOXE server "ip link add link $server_dev2 name $server_dev2.30 type vlan id 30" 
DOXE server "ip addr add 192.168.1.2/29 dev $server_dev2.30"
DOXE server "ip link set up dev $server_dev2.30"

echo Server vlan creada $server_dev2.30


# ---------------------------------------------------------- REDES POR VSWITCH ---------------------------------------------------------------------- #
switch=switch
ovs-vsctl add-br $switch
ip link set $switch up

# Server 

PADD $switch $server_dev "trunks=10,20,30 vlan_mode=trunk"


# CLIENTES:
for i in {1..2}; do
    PADD $switch ${cliente_dev[$i]} "tag=10 vlan_mode=access"
done

for i in {3..4}; do
    PADD $switch ${cliente_dev[$i]} "tag=20 vlan_mode=access"
done

for i in {5..8}; do
    PADD $switch ${cliente_dev[$i]} "tag=30 vlan_mode=access"
done

# ---------------------------------------------------------------------------

