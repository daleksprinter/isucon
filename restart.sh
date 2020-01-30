udo -H -u isucon bash -c 'cd /home/isucon/webapp/go && git fetch origin master && git reset --hard origin/master && make'
sudo systemctl stop isutar.go.service
sudo systemctl stop isuda.go.service
sudo systemctl start isutar.go.service
sudo systemctl start isuda.go.service
