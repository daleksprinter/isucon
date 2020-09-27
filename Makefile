all: isuumo

isuumo: *.go
	go build -o isuumo

logrotate:
	sudo sh -c " :>/var/log/mysql/mysql-slow.sql"
	sudo journalctl --rotate
	sudo journalctl --vacuum-time=1s

slackcat:
	slackcat --channel isucon-log mysql-log-profile

restartapp:
	sudo systemctl restart isuumo.go

mysqldump:
	sudo mysqldumpslow -s t /var/log/mysql/mysql-slow.sql > mysql-log-profile

initdb:
	/home/isucon/isuumo/webapp/mysql/db/init.sh

git:
	git fetch
	git merge origin/master

jounal:
	sudo journalctl -u isuumo.go
