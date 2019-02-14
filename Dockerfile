FROM centos:7

MAINTAINER Samuel Loza "starsaminf@gmail.com"

# Set timezone
ENV TIMEZONE America/La_Paz
RUN rm -f /etc/localtime && \
    ln -s /usr/share/zoneinfo/${TIMEZONE} /etc/localtime

RUN yum install -y epel-release yum-utils 
RUN yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
RUN yum-config-manager --enable remi-php71
RUN yum -y update
RUN yum install -y php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo php-mbstring php-xml php-zip

# httpd install
RUN yum install -y httpd

# Clean up, reduces container size
RUN rm -rf /var/cache/yum/* && yum clean all

# project root
RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app/public /var/www/html

# permission
RUN usermod -u 1000 apache
RUN groupmod -g 1000 apache
RUN chown -R apache:apache /app

# httpd conf
COPY conf.d/ /etc/httpd/conf.d/

# composer
RUN curl -sS https://getcomposer.org/installer | php && \
 mv composer.phar /usr/local/bin/composer &&\
 chmod +x /usr/local/bin/composer

# Apache start up script
ADD start-httpd.sh /start-httpd.sh
RUN chmod +x start-httpd.sh -v

EXPOSE 80

WORKDIR /app
CMD ["/start-httpd.sh"]
