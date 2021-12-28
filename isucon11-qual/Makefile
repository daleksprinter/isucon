cleanlog:
	sudo sh -c "echo '' > /var/log/nginx/accessltsv.log"
	sudo sh -c "echo '' > /var/log/slow.log"
	sudo journalctl --rotate
	sudo journalctl --vacuum-time=1s

alp:
	cat /var/log/nginx/accessltsv.log | alp ltsv -m '/api/condition/.*, /isu/.*' --sort sum -r

mysqldumpslow:
	mysqldumpslow -s t /var/log/slow.log

gobuild:
	cd /home/isucon/webapp/go && go build -o isucondition main.go

restart:
	sudo systemctl restart nginx
	sudo systemctl restart mysql
	sudo systemctl restart isucondition.go

journalctl:
	sudo journalctl -u isucondition.go

init: cleanlog gobuild restart

bench:
	/home/isucon/bench/bench -tls -target=192.168.0.11 -all-addresses=192.168.0.11,192.168.0.12,192.168.0.13 -jia-service-url http://192.168.0.10:5000

pprof:
	curl -s http://localhost:6060/debug/pprof/profile > cpu.pprof

pprofpng:
	go tool pprof -png go/isucondition cpu.pprof > out.png

pprofconsole:
	go tool pprof go/isucondition cpu.pprof
