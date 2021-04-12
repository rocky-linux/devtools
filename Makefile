.PHONY: all

all: srpmproc/srpmproc

.dnf:
	sudo yum -y install epel-release
	sudo yum -y groupinstall "Development Tools"
	sudo yum -y install golang mock nginx createrepo
	touch .dnf

.system:
	sudo dnf config-manager --set-enabled powertools
	sudo systemctl start nginx
	sudo systemctl enable nginx
	touch .system


srpmproc:
	git clone https://git.rockylinux.org/release-engineering/public/srpmproc.git
	cd srpmproc; git checkout -b working 99809a4ead5c3cc8907739365a07df35117a2669 # srpmproc HEAD is broken right now


srpmproc/srpmproc: srpmproc
	cd srpmproc; CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build ./cmd/srpmproc


install: srpmproc/srpmproc .dnf .system
	cp -r etc_mock/rocky* /etc/mock/
	cp -r etc_mock/templates/* /etc/mock/templates/
	install -m 755 srpmproc/srpmproc /usr/local/bin/
	install -m 755 bin/* /usr/local/bin/
	test -d /usr/share/nginx/html/repo || mkdir /usr/share/nginx/html/repo
	chmod 777 /usr/share/nginx/html/repo


clean:
	rm -rf srpmproc  $(HOME)/rocky 

# enable makefile to accept argument after command
#https://stackoverflow.com/questions/6273608/how-to-pass-argument-to-makefile-from-command-line

args = `arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`
%:
	@:
status:
	git status
commit:
	git commit -am "$(call args, Automated commit message without details, Please read the git diff)"  && git push
pull:
	git pull
help:
	@echo "Usage: make <target> <argument>"
	@echo
	@echo "Available targets are:"
	@echo "  all                    Default without argument"
	@echo "  help                   Showing this help "
	@echo "  install                Install devtool"
	@echo "  build  rpm-name        Ex: make build perl "
	@echo "  clean                  clean myrocky and srpmproc "
	@echo "  commit {"my message"}  ie, git commit, without or with real commit message"
	@echo "  status                 ie, git status"
	@echo "  pull                   ie, git pull"
	@echo ""

build:
	(mkdir -p $(HOME)/rocky && cd $(HOME)/rocky && rockyget $(filter-out $@,$(MAKECMDGOALS)))
	(cd $(HOME)/rocky/$(filter-out $@,$(MAKECMDGOALS))/r8 && rockybuild-notest)




