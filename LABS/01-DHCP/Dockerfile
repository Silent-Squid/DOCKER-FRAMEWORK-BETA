FROM ubuntu:26.04 

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update; apt-get install -y arping iproute2 iputils-ping nano kea software-properties-common; add-apt-repository universe; apt-get install -y supervisor; apt-get clean; rm -rf /var/lib/apt/lists/* \
    ;mkdir -p /var/lib/kea/; chmod 750 /var/lib/kea/; mkdir -p /run/kea/ ; chmod 750 /run/kea

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY KEA-CORP.conf /etc/kea/kea-dhcp4.conf

CMD ["/usr/bin/supervisord"]

EXPOSE 9991