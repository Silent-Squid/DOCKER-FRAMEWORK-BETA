# ¿QUÉ ES ESTO?
Esto es un intento de replicar la manera de lanzar contenedores de docker en kubernetes utilizando script y librerias propias para utilizar veth y
los switches virtuales de OVS (OpenVSwitch) para no depender del sistema de redes default en docker. Perfecto para laboratorios de SMR, ASIR o experimentos

# ¿Cuantos contenedores se pueden lanzar en un mismo archivo?

La respuesta a esta pregunta es, todos los que docker y tu sistema te permitan, no he encontrado ninguna limitación, icluso lanzando 12 y configurando las redes de
manera completamente 

# ¿Cómo funciona?
En el directorio */Script* tenemos todos los archivos que nos van a hacer falta para lanzar el script, yo los he separado en 3:
1. RunDocker.sh
2. network.sh
3. Depuracion.sh
## lib
1. lib-01.sh

## RunDocker.sh 
Este va a ser el archivo donde se lanzarán los contenedores que se deseen

## network.sh

## Depuracion.sh
Este archivo debe ser configurado para destruir los contenedores y los switches creados con RunDocker. Los veths asignados a los contenedores serán **automaticamente
borrados** por el sistema.


## Librerias: lib
1. lib-01.sh

# DOCS De otras herramientas utilizadas: 
Guía a markdown: 
: https://www.markdownguide.org/cheat-sheet/
