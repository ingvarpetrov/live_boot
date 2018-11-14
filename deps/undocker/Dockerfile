FROM phusion/baseimage
MAINTAINER ingvar.petrov

#Install basic tools
RUN apt-get update && apt-get install -y htop wget unzip sudo net-tools isc-dhcp-client pciutils iftop ifupdown libxml2 nano

### Consul
RUN wget https://releases.hashicorp.com/consul/1.3.0/consul_1.3.0_linux_amd64.zip && unzip consul_1.3.0_linux_amd64.zip && mv consul /usr/bin && rm consul_1.3.0_linux_amd64.zip &&\
mkdir /etc/consul.d 
COPY swarm.json /etc/consul.d
RUN mkdir /etc/service/consuld
COPY consuld.sh /etc/service/consuld/run
RUN chmod +x /etc/service/consuld/run

#Install node
RUN curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash - && \
sudo apt-get install -y nodejs

#Install artillery
RUN sudo npm install --unsafe-perm -g artillery


#Install Flussonic
RUN curl -sSf https://flussonic.com/raw/install.sh | sh
copy license.txt /etc/flussonic/license.txt

### SSH
RUN rm -f /etc/service/sshd/down
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

COPY id_rsa.pub /tmp/id_rsa.pub
RUN cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys && rm -f /tmp/id_rsa.pub
COPY resolv.conf /etc/resolvconf/resolv.conf.d/tail

## Networking

COPY interfaces /etc/network/interfaces
COPY mpegrouter /usr/bin/
COPY sysctl.conf /etc/sysctl.conf
