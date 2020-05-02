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

log:
	sudo journalctl -u isucari.golang

build:
	go build -o isucari

restart:
	sudo systemctl restart isucari.golang
	sudo systemctl restart nginx
	sudo systemctl restart mysql

pprof:
	pprof ./isucari http://localhost:6060/debug/pprof/profile?seconds=100


pprof-web:
	pprof -http=localhost:8080 ../pprof/pprof.isucari.samples.cpu.001.pb.gz

profile:
	make build
	make restart
	make log-rotate-nginx	
	make log-rotate-mysql
	make bench
	make kataribe
	make mysqldumpslow	
