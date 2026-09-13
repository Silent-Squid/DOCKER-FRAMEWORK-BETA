# ¿QUÉ ES ESTO y Cómo funciona?

Esto es un intento de replicar la manera de lanzar contenedores de Docker en Kubernetes utilizando scripts y librerías propias para emplear `veth` y los switches virtuales de **OVS (Open vSwitch)**, con el objetivo de no depender del sistema de redes por defecto de Docker.

Es perfecto para laboratorios de **SMR**, **ASIR** (certificaciones españolas) o experimentos.

Se puede considerar un **Framework de trabajo**. Fue diseñado en 2 días durante mis vacaciones de verano y tengo pensado mejorarlo, pero tampoco quiero dedicarle demasiado tiempo. No está pensado para entornos de producción, ya que apenas tiene herramientas para auditar los laboratorios y carece de un sistema de logs y seguridad. El funcionamiento correcto es de **responsabilidad exclusiva del usuario**.

Las redes, de momento, solo soportan **IPv4**. Tal vez en un futuro me plantee diseñarlo también para IPv6, solo que para trabajar en laboratorios me parece un dolor de cabeza. Aunque claro, tiene mejoras significativas y va a haber casos en los que se trabajará en IPv6. Lo valoraré...

Otra manera de calificar esto puede ser... **Mi juguete de laboratorio personal :3**

Es muy, muy crudo. Utiliza exclusivamente scripts. Sé que podría diseñar un sistema con un archivo YAML que recoja todas las configuraciones, como hace Docker por defecto. Pero como quería utilizar OVS, y las redes por defecto de Docker dan bastante asco para trabajar en redes, he recurrido a esto. Tampoco me quería meter mucho en Kubernetes, así que simplemente creé esto en 2 días.

---

## ¿Cuántos contenedores se pueden lanzar en un mismo archivo?

La respuesta a esta pregunta es: **todos los que Docker y tu sistema te permitan**. No he encontrado ninguna limitación, incluso lanzando 12 contenedores y configurando las redes de manera automática.

---

## ¿Cómo funciona?

En el directorio `/Script` tenemos todos los archivos que nos van a hacer falta. Yo los he separado en 3:

1. `RunDocker.sh`
2. `network.sh`
3. `Depuracion.sh`

### lib

1. `lib-01.sh`

---

### `RunDocker.sh`

Este va a ser el archivo donde se lanzarán los contenedores y switches que se deseen.

### `network.sh`

Este va a ser el archivo donde se configurarán las redes y los switches virtuales.

### `Depuracion.sh`

Este archivo debe ser configurado para destruir los contenedores y los switches creados con `RunDocker.sh`. Los `veth` asignados a los contenedores serán **automáticamente borrados** por el sistema.

---

## Librería `lib-01.sh`

Es una librería fundamental para el sistema de scripts. En ella están todas las funciones necesarias que se utilizarán en los scripts creados con este sistema.

De hecho, **lo más importante de este proyecto es la librería en sí**, ya que todo lo demás son laboratorios.

A partir de ahora, consideraremos esta librería como el **Framework de Redes**.

---

### Explicación de cada función

- **`random()`**
  Esta función genera un string de 4 caracteres (A-Z, a-z, 0-9). Es utilizada en otras funciones para generar identificadores únicos.

- **`RunDocker()`**
  Esta es una de las funciones principales. Lanza un contenedor de Docker utilizando sus parámetros `$1` y `$2`, donde `$1` = nombre y `$2` = imagen Docker. La configuración específica es:
  - `-it -d --network none --name $1 --cap-add=NET_ADMIN`

- **`PID()`**
  Extrae el PID del contenedor de Docker especificado en `$1`. Su uso principal es con otras funciones, pero también es útil para extraer el PID para ciertas operaciones.

- **`makeif()`**
  Esta es una de las funciones más complicadas del framework. Se utiliza para crear un `VETH` y asignarlo a un contenedor. Sus parámetros son:
  - `$1` — PID
  - `$2` — Contenedor
  - `$3` — Nombre de la interfaz
  - `$4` — IP + NETMASK (opcional). También es válido `DHCP4`, que por el momento no hace nada pero especifica y devuelve una variable indicando que el contenedor quiere DHCP4.

  La función devuelve los siguientes datos:
  - `dev`: Nombre del dispositivo de red en el host.
  - `dev2`: Nombre del dispositivo de red dentro del contenedor.
  - `DHCP4`: Si el contenedor espera tener DHCP o no.

- **`makeifs()`**
  Es igual que `makeif` pero mucho más sencillo y sin devolver ningún `echo`.

- **`MakeCLI()`**
  Es una función pensada para lanzar de manera masiva contenedores "clientes" con una configuración de red igual.
  - `$1` y `$2`: rango. `MakeCLI 1 5` crea 5 contenedores (clientes).
  - `$3`: dirección de red sin el último dígito. Si la red es `192.168.0.0`, deberá escribirse `192.168.0.`.
  - `$4`: rango desde el que se empezará a colocar las IPs. Si colocas 9, empezará a partir de 10. Esto está hecho para dejar siempre una IP para un servidor o cualquier otro dispositivo.
  - `$5`: máscara de red en formato CIDR (`/16`, `/24`...).
  - Un ejemplo de 3 clientes a partir de la `192.168.0.20/24`: `MakeCLI 1 3 192.168.0. 19 /24`

- **`PADD()`**
  Es una función simple para añadir un puerto a un vswitch de Open vSwitch.
  - `$1`: Switch
  - `$2`: Interfaz
  - `$3`: Configuración extra

- **`DOXE()`**
  Una función extremadamente simple, hecha para vagos que no quieren escribir `docker exec`. Sinceramente, la que más he usado a nivel de sistema operativo.
  - `$1`: Contenedor
  - `$2`: Comando

---

## LABS y DOCKER_FILES

El directorio `LABS` contiene algunos ejemplos de cómo yo he utilizado la herramienta, junto a los Dockerfiles en la carpeta `DOCKER_FILES`.

---

## DOCS de otras herramientas utilizadas

- Guía de Markdown:
  - https://www.markdownguide.org/cheat-sheet/
