# 使用官方的 Ubuntu 基础镜像
FROM ubuntu:22.04

# 设置环境变量，避免在安装过程中出现与交互相关的提示
ENV DEBIAN_FRONTEND=noninteractive

# 安装 MariaDB
RUN apt-get update \
    && apt-get install -y mariadb-server \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 安装 tzdata 包
RUN apt-get update && apt-get install -y tzdata && rm -rf /var/lib/apt/lists/*

# 设置环境变量（根据需要设置）
ENV MYSQL_ROOT_PASSWORD=root_password
ENV MYSQL_DATABASE=mydatabase
ENV MYSQL_USER=myuser
ENV MYSQL_PASSWORD=mypassword

# 拷贝启动脚本（可选，如果你需要自定义启动行为）
COPY ./startup.sh /startup.sh
RUN chmod +x /startup.sh

EXPOSE 3306
# 启动 MariaDB 服务器
CMD ["/startup.sh"]