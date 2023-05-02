all: build

.PHONY: clean
clean:
	rm -rf torb

deps:
	gb vendor restore

.PHONY: build
build:
	GOPATH=`pwd`:`pwd`/vendor go build -v torb
	sudo systemctl restart torb.go

profile:
	sudo sh -c "echo '' > /var/log/h2o/access.log"
	sudo sh -c "echo '' > /var/log/mariadb/slow.log"
	/home/isucon/torb/bench/bin/bench -data /home/isucon/torb/bench/data -remotes 118.27.14.111 -output bench_result.txt
	sudo cat /var/log/h2o/access.log | kataribe -conf /home/isucon/torb/bench/kataribe.toml > access_result.txt
	sudo mysqldumpslow -s t /var/log/mariadb/slow.log > mysql_result.txt
	slackcat --channel isucon-log bench_result.txt
	slackcat --channel isucon-log access_result.txt
	slackcat --channel isucon-log mysql_result.txt

pprof:
	pprof -pdf -output torb-pprof.pdf /home/isucon/torb/webapp/go/torb http://localhost:6060/debug/pprof/profile?seconds=100
	slackcat --channel isucon-log torb-pprof.pdf
