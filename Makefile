.PHONY: all

all: .go-setup srpmproc/srpmproc

.dnf:
	sudo dnf -y install epel-release
	sudo dnf -y groupinstall "Development Tools"
	sudo dnf -y install golang mock nginx createrepo git
	touch .dnf

.system:
	sudo dnf config-manager --set-enabled powertools
	sudo systemctl start nginx
	sudo systemctl enable nginx
	touch .system

.go-setup:
	go get gopkg.in/yaml.v2
	touch .go-setup
	

srpmproc:
	git clone https://github.com/rocky-linux/srpmproc.git


srpmproc/srpmproc: srpmproc
	cd srpmproc; GO111MODULE=auto CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build ./cmd/srpmproc


scriptinstall: 
	install -m 755 bin/* /usr/local/bin/

install: srpmproc/srpmproc .dnf .system scriptinstall
	cp -r etc_mock/rocky* /etc/mock/
	cp -r etc_mock/templates/* /etc/mock/templates/ || true
	install -m 755 srpmproc/srpmproc /usr/local/bin/
	test -d /usr/share/nginx/html/repo || mkdir /usr/share/nginx/html/repo
	chmod 777 /usr/share/nginx/html/repo


clean:
	rm -rf srpmproc

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




