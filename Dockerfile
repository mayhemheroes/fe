FROM --platform=linux/amd64 ubuntu:20.04 as builder

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential

ADD . /repo
WORKDIR /repo
RUN ./build.sh

RUN mkdir -p /deps
RUN ldd /repo/fe | tr -s '[:blank:]' '\n' | grep '^/' | \
    xargs -I % sh -c 'cp % /deps;'

FROM ubuntu:20.04

COPY --from=builder /deps /deps
COPY --from=builder /repo/fe /repo/fe
ENV LD_LIBRARY_PATH=/deps