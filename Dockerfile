FROM alpine:3.8 as sscep
RUN apk update && apk add --no-cache git make gcc libc-dev openssl-dev zlib-dev
RUN git clone https://github.com/certnanny/sscep.git
COPY static-makefile.patch sscep/
RUN cd sccep && patch < static-makefile.patch
RUN cd sscep && ./Configure  && make OPENSSL=/usr/lib

FROM alpine:3.8 as nanny
RUN apk add git make gcc perl
RUN git clone https://github.com/certnanny/CertNanny.git
RUN cd CertNanny && make 


FROM alpine:3.8
COPY --from sscep /sscep/sccep_static /opt/
COPY --from nanny 
