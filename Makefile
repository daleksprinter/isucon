all: isuumo

isuumo: *.go
	go build -o isuumo

logrotate:
	sudo sh -c " :>/var/log/mysql/mysql-slow.sql"

slackcat:
	slackcat --channel isucon-log mysql-log-profile

restartapp:
	sudo systemctl restart isuumo.go

