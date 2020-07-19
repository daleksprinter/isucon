sudo sh -c "echo '' > /var/log/nginx/access.log"
sudo sh -c "echo '' > /var/log/mysql/mysql-slow.sql"
/home/isucon/isubata/bench/bin/bench -data=/home/isucon/isubata/bench/data -remotes=localhost -output=result.json
slackcat --channel isucon-log result.json
