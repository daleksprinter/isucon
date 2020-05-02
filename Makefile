export GO111MODULE=on
GOOS=linux 
GOARCH=amd64

all: isucari

isucari: *.go
	go build -o isucari

log-rotate-nginx:
	sudo sh -c "echo '' > /var/log/nginx/access.log"

log-rotate-mysql:
	sudo sh -c "echo '' > /var/log/mysql/mysql-slow.log"

kataribe:
	sudo cat /var/log/nginx/access.log | kataribe -conf /home/isucon/kataribe.toml > result-nginx.log

mysqldumpslow:
	sudo sh -c "mysqldumpslow -s t /var/log/mysql/mysql-slow.log > result-mysql.log"

bench:
	/home/isucon/isucari/bin/benchmarker -target-url http://127.0.0.1 -data-dir /home/isucon/isucari/initial-data -static-dir /home/isucon/isucari/webapp/public/static 
	sudo journalctl -u isucari.golang > result-golang.log

build:
	go build -o isucari
	sudo systemctl restart isucari.golang


pprof:
	make bench &
	pprof ./isucari http://localhost:6060/debug/pprof/profile?seconds=100


