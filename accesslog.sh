sudo cat /var/log/nginx/access.log | kataribe > nginx-access.log
slackcat --channel isucon-log nginx-access.log
