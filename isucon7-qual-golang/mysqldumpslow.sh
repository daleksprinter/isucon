sudo mysqldumpslow -s t /var/log/mysql/mysql-slow.sql > mysql-slow.log
slackcat --channel isucon-log mysql-slow.log

