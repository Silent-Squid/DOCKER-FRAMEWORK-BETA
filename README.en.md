# WHAT IS THIS and How does it work?

This is an attempt to replicate the way Docker containers are launched in Kubernetes using custom scripts and libraries that use `veth` and **OVS (Open vSwitch)** virtual switches, so as not to depend on Docker's default network system. It's perfect for **SMR**, **ASIR** (Spanish certifications) labs, or experiments.

It can be considered a **working framework**. It was designed in 2 days during my summer holidays, and I plan to improve it, but I don't want to spend too much time on it. It's not meant for production environments, as it barely has tools to audit the labs and lacks a logging and security system. Correct operation is the **sole responsibility of the user**.

The networks currently only support **IPv4**. Maybe in the future I'll consider designing it for IPv6 too, but for working in labs, IPv6 seems like a headache. Although, of course, it has significant improvements and there will be cases where IPv6 will be used. I'll consider it...

Another way to describe this could be... **My personal lab toy :3**

It's very, very raw. It uses only scripts. I know I could design a system with a YAML file that gathers all the configurations, like Docker does by default. But since I wanted to use OVS, and Docker's default networks are pretty nasty for working with networks, I went with this. I also didn't want to get too deep into Kubernetes, so I just built this in 2 days.

---

## How many containers can be launched in a single file?

The answer is: **as many as Docker and your system allow**. I haven't found any limitations, even when launching 12 containers and configuring the networks automatically.

---

## How does it work?

In the `/Script` directory, we have all the files we'll need. I've separated them into 3:

1. `RunDocker.sh`
2. `network.sh`
3. `Depuracion.sh`

### lib

1. `lib-01.sh`

---

### `RunDocker.sh`

This is the file where the containers and switches you want will be launched.

### `network.sh`

This is the file where the networks and virtual switches will be configured.

### `Depuracion.sh`

This file must be configured to destroy the containers and switches created with `RunDocker.sh`. The `veth` interfaces assigned to the containers will be **automatically deleted** by the system.

---

## Library `lib-01.sh`

It's a fundamental library for the script system. It contains all the necessary functions that will be used in the scripts created with this system.

In fact, **the most important part of this project is the library itself**, since everything else is just labs.

From now on, we'll consider this library as the **Network Framework**.

---

### Explanation of each function

- **`random()`**
  This function generates a 4-character string (A-Z, a-z, 0-9). It's used in other functions to generate unique identifiers.

- **`RunDocker()`**
  This is one of the main functions. It launches a Docker container using its parameters `$1` and `$2`, where `$1` = name and `$2` = Docker image. The specific configuration is:
  - `-it -d --network none --name $1 --cap-add=NET_ADMIN`

- **`PID()`**
  Extracts the PID of the Docker container specified in `$1`. Its main use is with other functions, but it's also useful for extracting the PID for certain operations.

- **`makeif()`**
  This is one of the most complex functions in the framework. It's used to create a VETH and assign it to a container. Its parameters are:
  - `$1` — PID
  - `$2` — Container
  - `$3` — Interface name
  - `$4` — IP + NETMASK (optional). `DHCP4` is also valid, which currently does nothing but specifies and returns a variable indicating that the container wants DHCP4.

  The function returns the following data:
  - `dev`: Name of the network device on the host.
  - `dev2`: Name of the network device inside the container.
  - `DHCP4`: Whether the container expects to have DHCP or not.

- **`makeifs()`**
  Same as `makeif` but much simpler and without returning any echo.

- **`MakeCLI()`**
  This function is designed to massively launch "client" containers with the same network configuration.
  - `$1` and `$2`: range. `MakeCLI 1 5` creates 5 containers.
  - `$3`: network address without the last digit (e.g., `192.168.0.`).
  - `$4`: range from which IPs will start being assigned. If you set 9, it will start at 10. This is done to always leave an IP for a server or any other device.
  - `$5`: network mask in CIDR format (`/16`, `/24`...).
  - Example of 3 clients starting from `192.168.0.20/24`: `MakeCLI 1 3 192.168.0. 19 /24`

- **`PADD()`**
  A simple function to add a port to an Open vSwitch virtual switch.
  - `$1`: Switch
  - `$2`: Interface
  - `$3`: Extra configuration

- **`DOXE()`**
  An extremely simple function, made for lazy people who don't want to type `docker exec`. Honestly, the one I've used the most at the OS level.
  - `$1`: Container
  - `$2`: Command

---

## LABS and DOCKER_FILES

The `LABS` directory contains some examples of how I've used the tool, along with the Dockerfiles in the `DOCKER_FILES` folder.

---

## DOCS for other tools used

- Markdown guide:
  - https://www.markdownguide.org/cheat-sheet/
