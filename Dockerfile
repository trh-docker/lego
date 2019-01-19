FROM quay.io/spivegin/golang_dart_protoc_dev AS build-env
WORKDIR /opt/src/src/github.com/xenolf/

RUN apt-get -y update && apt-get -y upgrade && \
    apt-get -y install gcc && apt-get -y autoremove && apt-get -y clean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ENV GO111MODULE=on
RUN git clone https://github.com/xenolf/lego.git
RUN cd lego &&\
    go mod init && go mod tidy && go mod vendor &&\
    make build

FROM quay.io/spivegin/tlmbasedebian
RUN mkdir -p /opt/bin
WORKDIR /opt/lego
COPY --from=build-env /opt/src/src/github.com/xenolf/lego/dist/lego /opt/bin/lego
RUN chmod +x /opt/bin/lego && ln -s /opt/bin/lego /bin/lego
CMD ["lego"]
