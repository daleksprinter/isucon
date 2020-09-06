# ISUCONやること

## Gitセットアップ
1. webappをgit initする
2. nginx.conf, my.cnfをwebappに移動、symlinkを貼る
```
mv /etc/nginx/sites-avaliable/${nginx_conf_file} ${app_dir}
ln -sfv ${app_dir} /etc/nginx/sites-available/${nginx_conf_file}

mv /etc/nginx/nginx.conf ${app_dir}
ln -sfv ${app_dir} /etc/nginx/nginx.conf

mv /etc/mysql/mysql.conf ${app_dir}
ln -sfv ${app_dir} /etc/mysql/mysql.conf
```
3. commit & pushしておく

## 各種スクリプト作成
アプリケーションのディレクトリにMakefile作る
1. ベンチマーク
2. ログローテート
```
cp /var/log/nginx/access.log access.log.$(date "+%Y%m%d%H%M%S").bak
```

## kataribeをインストール
##### Repo `https://github.com/matsuu/kataribe`
1. `go get -u github.com/matsuu/kataribe`
2. `kataribe -generate`
3. nginx.confの編集
```
log_format with_time '$remote_addr - $remote_user [$time_local] '
                     '"$request" $status $body_bytes_sent '
                     '"$http_referer" "$http_user_agent" $request_time';
access_log /var/log/nginx/access.log with_time;
```
4. ベンチマーカーがnginxに向いているか確認し、ベンチ回す
5. `sudo cat /var/log/nginx/access.log | kataribe > access-log-profile` でアクセスログをプロファイリング

## MySQL_Dump_Slow
1. mysql.cnfに以下を追加
```
[mysqld]
slow_query_log = 1
slow_query_log_file = /var/log/mysql/mysql-slow.sql
long_query_time = 0
```
2. MySQLに設定の読み込みを行い、リスタート
3. MySQLの設定を確認する
```
show variables like 'slow%';
```

4.設定が書き変わっていない場合
- /etc/mysql/my.cnfがworld writableな権限になっていないか確認

5.プロファイル
```
sudo mysqldumpslow -s t /var/log/mysql/mysql-slow.sql > mysql-log-profile
```

## Slackcatをインストール
##### Repo `https://github.com/bcicen/slackcat`
1. Install
```
curl -Lo slackcat https://github.com/bcicen/slackcat/releases/download/v1.6/slackcat-1.6-$(uname -s)-amd64
sudo mv slackcat /usr/local/bin/
sudo chmod +x /usr/local/bin/slackcat
```
2. Configure
`slackcat --configure`の後に`http://slackcat.chat/configure`にアクセス
3. Slackに投稿
- アクセスログプロファイル `slackcat --channel isucon-log access-log-profile`
- MySQLダンプログプロファイル `slackcat --channel isucon-log mysql-log-profile`
