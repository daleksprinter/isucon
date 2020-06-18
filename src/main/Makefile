all: deps app.go
	go build -o app

.PHONY: deps
deps: dep Gopkg.toml Gopkg.lock
	dep ensure

.PHONY: dep
dep:
ifeq ($(shell command -v dep 2> /dev/null),)
	go get -u github.com/golang/dep/...
endif


mysqldump:
	sudo sh -c 'mysqldumpslow -s t /var/log/mysql/mysql-slow.sql' > result-mysql

accesslog:
	sudo cat /var/log/nginx/access.log | kataribe

