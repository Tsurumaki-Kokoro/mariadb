#!/bin/bash

# 初始化 MariaDB 数据库，如果目录为空
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --ldata=/var/lib/mysql
fi

# 启动 MariaDB 服务器
mysqld_safe &

sleep 10  # 等待 MariaDB 服务完全启动，这个时间可以根据需要进行调整

# 设置 root 密码和创建用户、数据库
mysql -uroot <<-EOF
UPDATE mysql.user SET Password=PASSWORD('${MYSQL_ROOT_PASSWORD}') WHERE User='root';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
EOF

# 加载时区数据
mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -uroot -p${MYSQL_ROOT_PASSWORD} mysql

# 将控制权交给 mysqld
wait $!