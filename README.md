# ¿QUÉ ES ESTO y Cómo funciona?
Esto es un intento de replicar la manera de lanzar contenedores de docker en kubernetes utilizando script y librerias propias para utilizar veth y
los switches virtuales de OVS (OpenVSwitch) para no depender del sistema de redes default en docker. Perfecto para laboratorios de SMR, ASIR o experimentos.

Se puede considerar un Framework de trabajo, fue diseñado en 2 días en mis vacaciones de verano y tengo pensado en mejorarlo, pero tampoco le quiero dedicar demasiado tiempo,
no está pensado para entornos de producción, ya que apenas tiene herramientas para auditar los laboratorios y carece de un sistema de logs y seguridad. El funcionamiento correcto
es de responsabilidad exclusiva del usuario. 

**¿Cuantos contenedores se pueden lanzar en un mismo archivo?**:

La respuesta a esta pregunta es, todos los que docker y tu sistema te permitan, no he encontrado ninguna limitación, icluso lanzando 12 y configurando las redes de
manera completamente 

## ¿Cómo funciona?
En el directorio */Script* tenemos todos los archivos que nos van a hacer falta para lanzar el script, yo los he separado en 3:
1. RunDocker.sh
2. network.sh
3. Depuracion.sh
## lib
1. lib-01.sh

## RunDocker.sh 
Este va a ser el archivo donde se lanzarán los contenedores y switches que se deseen

## network.sh
Este va a ser el archivo donde sde configurarán las redes y los virtual-switches 

## Depuracion.sh
Este archivo debe ser configurado para destruir los contenedores y los switches creados con RunDocker. Los veths asignados a los contenedores serán **automaticamente
borrados** por el sistema.


# Libreria lib-01.sh
Es una librería fundamental para el sistema de script, en ella están todas las funciones necesarias y que se utilizarán en los scripts creados con este sistema. De hecho, 
lo más importante de este proyecto es la librería en sí, ya que todo lo demás son laboratorios. A partir de ahora consideraremos esta librería como el **Framework de redes**

Explicaré como funciona cada función de la librería 
- *random()*
: Esta función genera un string de 4 caracteres de los cuales van de la A-Z a-z 0-9, es utilizada en otras funciones para generar "identificadores únicos" para utilizar.

- *RunDocker()*
: Esta es una de las funciones principales, lanza un contenedor de docker utilizando sus parámetros $1 y $2 donde $1 = nombre y $2 = imagen docker. La configuración específica es
  - *"-it -d --network none --name $1 --cap-add=NET_ADMIN"*

- *PID()*
: Extrae el PID del contenedor de docker especificado en $1. Su uso principal es con otras funciones, pero también es útil para extraer el PID para ciertas operaciones

- *makeif()*
: Esta es una de las funciones más complicadas del framework, se utiliza para crear un VETH y asignarlo a un contenedor, sus parámetros son:
  - $1 ---- PID
  - $2 ---- Contenedor
  - $3 ---- NombreIF
  - $4 ---- IP + NETMASK  OPTIONAL. Tambien es valido DHCP4 que por el momento no hace nada pero especifica y devuelve una variable indicando que el contenedor quiere DHCP4
 


# DOCS De otras herramientas utilizadas: 
Guía a markdown: 
: https://www.markdownguide.org/cheat-sheet/
