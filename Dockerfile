##################################  Notes  ##################################
# build:
#   docker build --no-cache -t unode .
#
# run:
#   docker run -it -p 15015:15015 unode
#
# run with a mounted directory for ~/.Unode:
#   docker run -it -p 15015:15015 -v /path/to/a/local/directory:/root/.Unode unode
#
# run will exec you into docker /bin/bash
# from there, you can run:
# unoded # starts the unode deamon
#
# For accessing the unode JSON-RPC api from the host:
# 1. Expose RPC port in when running docker
#    docker run -it -p 15015:15015 -p 5000:XXX -v /path/to/a/local/directory:/root/.Unode unode # Replace XXX with set rpcPort in unode.conf
# 2. From host access the API via:
# `curl --user rpc_user:rpc_pass --data '{"method": "getinfo"}' http://127.0.0.1:5000`
#############################################################################

FROM ubuntu:16.04

# Build essentials
RUN apt-get update && apt-get -y install git vim build-essential g++ libdb++-dev libminiupnpc-dev libtool automake autotools-dev \
    autoconf pkg-config libssl-dev libgmp3-dev \
    libevent-dev bsdmainutils libboost-all-dev \
    apt-transport-https ca-certificates curl gnupg2 \
    software-properties-common

# Berkeley DB 4.8
RUN echo "deb http://ppa.launchpad.net/bitcoin/bitcoin/ubuntu trusty main" | tee /etc/apt/sources.list.d/bitcoin-ppa.list
RUN apt-get update
RUN apt-get -y --allow-unauthenticated install libdb4.8-dev libdb4.8++-dev

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/Unode/Unode.git Unode && cd Unode/src/ && make -f makefile.unix && cp unoded /usr/local/sbin/unoded

RUN mkdir /root/.Unode/

CMD ["/bin/bash"]
