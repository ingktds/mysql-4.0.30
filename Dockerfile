FROM gpmidi/centos-5.6
MAINTAINER ingktds <tadashi.1027@gmail.com>

ENV MYSQL_VER="4.0.30" WORK_DIR="/usr/local/src"
ADD mysql-${MYSQL_VER}.tar.gz ${WORK_DIR}/
RUN yum -y install gcc \
                   gcc-c++ \
                   make \
                   tar \
                   ncurses-devel \
                   vim-enhanced &&\

    # MySQL Setup
    groupadd mysql &&\
    useradd -g mysql mysql &&\
    cd ${WORK_DIR} &&\
    cd mysql-${MYSQL_VER} &&\
    ./configure --prefix=/usr/local/mysql &&\
    make &&\
    make install &&\
    cp support-files/my-medium.cnf /etc/my.cnf &&\
    cd /usr/local/mysql &&\
    bin/mysql_install_db --user=mysql &&\
    chown -R root  . &&\
    chown -R mysql var &&\
    chgrp -R mysql . &&\
    sed -i "s/^log-bin/log-bin = mysql-bin/" /etc/my.cnf &&\

    # Timezone Setting
    cp -p /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

EXPOSE 3306
ENTRYPOINT ["/usr/local/mysql/bin/mysqld_safe"]
