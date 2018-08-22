FROM alpine:3.8 as sscep
RUN apk update && apk add --no-cache git make gcc libc-dev openssl-dev zlib-dev
RUN git clone https://github.com/certnanny/sscep.git
COPY static-makefile.patch sscep/
RUN cd sscep/ && ./Configure  && patch < static-makefile.patch && make OPENSSL=/usr/lib

FROM alpine:3.8 as nanny
RUN apk add git make gcc perl
RUN git clone https://github.com/certnanny/CertNanny.git
RUN cd CertNanny && make 



FROM alpine:3.8
RUN apk add --no-cache bash perl

RUN mkdir -p /opt/cert/

COPY --from=sscep /sscep/sscep_static /opt/cert/
COPY --from=nanny /CertNanny/bin/ /opt/cert/bin
COPY --from=nanny /CertNanny/lib/ /opt/cert/lib
COPY --from=nanny /CertNanny/etc/ /opt/cert/etc
