# This dockerfile uses the ubuntu image
# VERSION 1 - EDITION 1
# Author: Yale Huang
# Command format: Instruction [arguments / command] ..

# Base image to use, this must be set as the first line
FROM ubuntu

MAINTAINER Yale Huang <calvino.huang@gmail.com>

# Commands to update the image
RUN apt-get -y update && apt-get -y upgrade

# Install shadowsocks-libev
RUN apt-get install build-essential autoconf libtool libssl-dev git \
	wget supervisor -y
RUN apt-get install --no-install-recommends build-essential autoconf libtool libssl-dev libpcre3-dev asciidoc xmlto -y
RUN git clone https://github.com/shadowsocks/shadowsocks-libev.git /root/shadowsocks-libev
RUN cd /root/shadowsocks-libev && ./configure && make
RUN cd /root/shadowsocks-libev/src && install -c ss-server /usr/bin
RUN wget -O /root/kcptun-linux-amd64.tar.gz https://github.com/xtaci/kcptun/releases/download/v20161009/kcptun-linux-amd64-20161009.tar.gz
RUN mkdir -p /opt/kcptun && cd /opt/kcptun && tar xvfz /root/kcptun-linux-amd64.tar.gz
RUN rm -rf /root/shadowsocks-libev
COPY supervisord.conf /etc/supervisord.conf

ENV SS_PASSWORD=1234567 SS_METHOD=aes-256-cfb \
	KCP_MTU=1350 KCP_MODE=fast KCP_KEY=123456789

EXPOSE 41111/udp 8338/tcp

CMD ["/usr/bin/supervisord"]

