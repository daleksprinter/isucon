cleanlog:
	sudo echo '' > /var/log/nginx/accessltsv.log
	sudo echo '' > /var/log/slow.log
	sudo journalctl --rotate
	sudo journalctl --vacuum-time=1s

alp:
	echo alp

mysqldumpslow:
	mysqldumpslow /var/log/slow.log

gobuild:
	cd /home/isucon/webapp/go && go build -o isucondition main.go

restart:
	sudo systemctl restart nginx
	sudo systemctl restart mysql
	sudo systemctl restart isucondition.go
