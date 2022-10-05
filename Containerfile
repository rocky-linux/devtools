FROM golang:1.16 as srpmproc
ARG srpmproc_version=v0.3.9
ENV srpmproc_version=$srpmproc_version
RUN git clone https://github.com/rocky-linux/srpmproc /go/src/github.com/rocky-linux/srpmproc/
WORKDIR /go/src/github.com/rocky-linux/srpmproc/
RUN git checkout $srpmproc_version
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o srpmproc ./cmd/srpmproc 

FROM docker.io/neilresf/scratch:minimal as dnf
RUN microdnf -y upgrade
RUN sed -i 's/enabled=0/enabled=1/g' /etc/yum.repos.d/Rocky-PowerTools.repo
RUN microdnf -y install epel-release
RUN microdnf -y install rpm-build mock createrepo git-core \
   autoconf \
   automake \
   binutils \
   bison \
   flex \
   gcc \
   gcc-c++ \
   gdb \
   glibc-devel \
   libtool \
   make \
   pkgconf \
   pkgconf-m4 \
   pkgconf-pkg-config \
   redhat-rpm-config \
   rpm-build \
   rpm-sign \
   strace \
   asciidoc \
   byacc \
   ctags \
   diffstat \
   elfutils-libelf-devel \
   git \
   intltool \
   jna \
   ltrace \
   patchutils \
   perl-Fedora-VSP \
   perl-Sys-Syslog \
   perl-generators \
   pesign \
   source-highlight \
   systemtap \
   valgrind \
   valgrind-devel \
   cmake \
   expect \
   rpmdevtools \
   rpmlint


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

FROM base as prep
ARG PACKAGE
ENV PACKAGE=$PACKAGE
ARG BRANCH
ENV BRANCH=$BRANCH

#RUN env
#RUN /entrypoint.sh get


FROM prep
WORKDIR /root/rocky/
RUN for a in get prep build; do echo "alias $a=rocky$a" >> /root/.bashrc; done

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["prep", "build"]
