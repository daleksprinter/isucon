webserver_log = /var/log/h2o/access.log
db_slowlog = /var/log/mysql/mysql-slow.sql
bench_cmd = 'cd ~/torb/bench && ./bin/bench -remotes "localhost:80"'

webserver_log_profile = access-log-profile
db_slowlog_profile = mysql-log-profile
pprof_profile = profile.pdf
app_bin = ./torb

all: build

.PHONY: clean
clean:
	rm -rf torb

deps:
	gb vendor restore

.PHONY: build
build:
	GOPATH=`pwd`:`pwd`/vendor go build -v torb

profile: logrotate bench profiling slackcat

logrotate:
	: | sudo tee $(webserver_log)
	: | sudo tee $(db_slowlog)

bench:
	bash -c $(bench_cmd)

profiling:
	sudo cat $(webserver_log) | kataribe > $(webserver_log_profile)
	sudo mysqldumpslow -s t $(db_slowlog) > $(db_slowlog_profile)

slackcat:
	slackcat --channel isucon $(webserver_log_profile)
	slackcat --channel isucon $(db_slowlog_profile)

pprof:
	go tool pprof $(app_bin) http://localhost:6060/debug/pprof/profile?seconds=60

pprof-slackcat:
	$(eval dump := $(shell ls --sort=time ~/pprof | head -n1))
	go tool pprof -pdf ~/pprof/$(dump) > $(pprof_profile)
	slackcat --channel isucon $(pprof_profile)
