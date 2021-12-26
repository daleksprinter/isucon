init:
	echo '' > /var/log/nginx/accessltsv.log
	echo '' > /var/log/slow.log

alp:
	echo alp

mysqldumpslow:
	echo mysql

gobuild:
	cd /home/isucon/webapp/go && go build -o isucondition main.go
