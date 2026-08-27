FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update; apt install -y iproute2 netplan.io traceroute arping iputils-ping isc-dhcp-client curl vim less ; apt clean;

CMD ["bin/bash"]


