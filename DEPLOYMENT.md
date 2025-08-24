# Deployment of Zabbix components on Ubuntu 24.04 LTS (Noble)

## Gain root-privilege

```sh
    $ sudo -s
```

## Setup MariaDB/MySQL server

### Install MariaDB

```sh
   $  apt update
   $  apt update
   $  apt install mariadb-server mariadb-client -y
```

### Change default root password

```sh
   $  mysql_secure_installation
   $  mysql -uroot -p
```

- MariaDB default password is blank.

### Prepare dedicated database and account for zabbix

```sh
    $ mysql -uroot -p
    password:
```

```mysql
    mysql> create database zabbix character set utf8mb4 collate utf8mb4_bin;
    mysql> create user zabbix@localhost identified by '$ZABBIX_DB_PASSWD';
    mysql> grant all privileges on zabbix.* to zabbix@localhost;
    mysql> set global log_bin_trust_function_creators = 1;
    mysql> quit;
```

## Setup Zabbix server and its component

### register Zabbix repository

```sh
    $ wget https://repo.zabbix.com/zabbix/7.4/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.4+ubuntu24.04_all.deb
    $ dpkg -i zabbix-release_latest_7.4+ubuntu24.04_all.deb
    $ apt update
```

### Install Zabbix server, frontend, agent2

```sh
    $ apt install zabbix-server-mysql zabbix-frontend-php zabbix-nginx-conf zabbix-sql-scripts zabbix-agent2
```

- Optional : Install Zabbix agent 2 plugins

```sh
    $ apt install zabbix-agent2-plugin-mongodb zabbix-agent2-plugin-mssql zabbix-agent2-plugin-postgresql
```

### Import initial schema and data.

```sh
    $ zcat /usr/share/zabbix/sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix
    password $ZABBIX_DB_PASSWD
```

## Disable log_bin_trust_function_creators option on MariaDB

```sh
    $ mysql -uroot -p
    password
```

```mysql
    mysql> set global log_bin_trust_function_creators = 0;
    mysql> quit;
```

## Configure the database connection strings for Zabbix server

```sh
    $ vim /etc/zabbix/zabbix_server.conf
```

```sh title="/etc/zabbix/zabbix_server.conf"
DBPassword=$ZABBIX_DB_PASSWD
```

## Configure PHP for Zabbix frontend

```sh
    $ vim /etc/zabbix/nginx.conf
```

```sh title="/etc/zabbix/nginx.conf"
listen 8080;
server_name example.com;
```

## Start Zabbix server and agent processes

```sh
    $ systemctl restart zabbix-server zabbix-agent nginx php8.3-fpm
    $ systemctl enable zabbix-server zabbix-agent nginx php8.3-fpm
```

## Allow ingress traffic to Zabbix server

For Active mode where:

AGENT --> FIREWALL --> SERVER

**TCP port 10050** must be allowed.

## Configure Zabbix agent

**For Active mode:**

```sh
    $ vim /etc/zabbix/zabbix_agentd.conf
Server=::/0,0.0.0.0/0
ServerActive=$SERVER_IP
Hostname=hostname-of-running-agent
```
