#!/bin/bash
#Generador aleatorio de 9 digitos 
random(){
    echo $(openssl rand -base64 10 | tr -dc 'a-zA-Z0-9' | head -c4)
}

RunDocker(){
    printf "\nLaunching $1 ----- image $2\n"
    #Donde $1 = nombre y $2 = imagen docker = $2 del sistema
    docker run -it -d --network none --name $1 --cap-add=NET_ADMIN $2
}

#Extractor de PID
PID() {
    echo $(docker inspect -f '{{.State.Pid}}' "$1")
}

#MAKEIF TUTORIAL
#Crea un veth y lo asigna a un contenedor. El veth no puede tener más de 15 caractéres
#$1 ---- PID
#$2 ---- Contenedor
#$3 ---- NombreIF
#$4 ---- IP + NETMASK  OPTIONAL

makeif(){
    randomNum=$(random)
    converted=$(echo $3 | tr -dc 'a-zA-Z0-9')
    
    dev=$(echo $converted-$randomNum | tail -c15)
    dev2=$(echo $dev-I| tail -c15 ) 

    pid=$1

# Creación de las interfaces

    ip link add $dev type veth peer $dev2
    ip link set $dev2 netns $pid

# Aplicando la dirección :) - BTW todo este código ha sido escrito por mí, Muchas gracias por leerlo y utilizarlo.
    string="DHCP4"
    if [[ $4 == $string ]] ; then

        echo Servidor DHCP4 esperado
        DHCP4=TRUE

    elif [[ -n $4 ]]; then

        ip=$4
        
        docker exec $2 ip addr add $ip dev $dev2
        if [[ $? = 0 ]]; then
            echo Configurada ip de $2 como $4
            DHCP4=FALSE
        else
            echo Se falló al configurar la IP
            DHCP4=FALSE
        fi
    else
        echo no IP configurada
    fi
    unset string

# Levantando las interfaces    
    ip link set $dev up
    docker exec $2 ip link set $dev2 up

    export dev="$dev"
    export dev2=$dev2
    export DHCP4="$DHCP4"
}

makeifs(){
   randomNum=$(random)
    converted=$(echo $3 | tr -dc 'a-zA-Z0-9')
    
    dev=$(echo $converted-$randomNum | tail -c15)
    dev2=$3 

    pid=$1

    ip link add $dev type veth peer $dev2
    ip link set $dev2 netns $pid

    echo $2 $dev $dev2 creados

# Levantando las interfaces    
    ip link set $dev up
    docker exec $2 ip link set $dev2 up

    export DHCP4="$DHCP4"
    export dev="$dev"
    export dev2="$dev2"
}

#$1 y $2 rango, del 1 al 2 MakeCLI 1 2
#4 Network o DHCP $4 Rango $5 Máscara de red en CIDR . A la IP estática se le sumará el valor del rango es decir si es cliente2 se le sumarán 2s
#
# Un ejemplo de 3 clientes con a partir de la 192.168.0.20/24
# MakeCLI 1 3 192.168.0. 19 /24
MakeCLI(){
    cliente=("-")
    cliente_dev2=("-")
    cliente_dev=("-")
    cliente_dhcp4=("")
    for i in $(seq $1 $2); do

        string=DHCP4
       
        if [[ -z $3 ]]; then
            echo Ignorando la Red 

        elif [[ $3 == $string ]]; then
            
            ip=$3

        else
            ip=$(echo $3$(($4 + $i))$5)
        fi

        unset $string

        makeif $(PID "cliente$i") cliente$i cli$i $ip

        cliente+=("$(PID cliente$i)") 
        cliente_dev+=("$dev")
        cliente_dev2=("$dev2")
        cliente_dhcp4=("$DHCP4")
 
    
    done

    export cliente
    export cliente_dev
    export cliente_dev2
    export cliente_dhcp4
}


PADD(){
    ovs-vsctl add-port $1 $2 $3
}

DOXE(){
    docker exec $1 $2
}


#el MAXI DESTRUCTOR de contenedores
DockerDestroy() {
    docker rm -f $1
}