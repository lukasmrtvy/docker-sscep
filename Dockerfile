FROM alpine:3.8
RUN apk update && apk add --no-cache git make gcc libc-dev openssl-dev zlib-dev
RUN git clone https://github.com/certnanny/sscep.git
COPY static-makefile.patch sscep/
RUN cd sccep && patch < static-makefile.patch
RUN cd sscep && ./Configure  && make OPENSSL=/usr/lib
