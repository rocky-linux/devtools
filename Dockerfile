FROM golang:1.16 as srpmproc
ARG srpmproc_version=v0.1.1
RUN git clone https://github.com/rocky-linux/srpmproc /go/src/github.com/rocky-linux/srpmproc/
WORKDIR /go/src/github.com/rocky-linux/srpmproc/
RUN git checkout $srpmproc_version
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o srpmproc ./cmd/srpmproc 

FROM rockylinux:8 as dnf
RUN dnf -y upgrade
RUN sed -i 's/enabled=0/enabled=1/g' /etc/yum.repos.d/Rocky-PowerTools.repo
RUN dnf -y install epel-release
RUN dnf -y install rpm-build mock @"Development Tools" createrepo git-core


FROM dnf as devtools
COPY etc_mock/rocky* /etc/mock/
COPY etc_mock/templates/* /etc/mock/templates/
COPY bin/* /usr/local/bin/
RUN chmod 0755 /usr/local/bin/rocky*


FROM devtools as base
COPY --from=srpmproc /go/src/github.com/rocky-linux/srpmproc/srpmproc /usr/local/bin/srpmproc
ARG user=root
RUN usermod -a -G mock $user
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

FROM base as builder
ARG package
ARG branch=r8
ENV PACKAGE=$package
CMD [ "/entrypoint.sh" ]
