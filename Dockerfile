FROM centos:6.7

MAINTAINER Samuel Loza "starsaminf@gmail.com"

# Set timezone
ENV TIMEZONE America/La_Paz
RUN rm -f /etc/localtime && \
    ln -s /usr/share/zoneinfo/${TIMEZONE} /etc/localtime

# Additional Repos

RUN yum -y install http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm \
    http://rpms.famillecollet.com/enterprise/remi-release-6.rpm \
    yum-utils wget unzip && \
    yum-config-manager --enable remi

# php install
RUN yum install -y \
  php70W \
  php70W-devel \
  php70W-mysql \
  php70W-common \
  php70W-mbstring \
  php70W-cli \
  php70W-pear \
  php70W-mcrypt \
  php70W-process \
  php70W-soap \
  php70W-gd  \
  php70W-opcache  \
  php70W-pdo  \
  php70W-pear \
  php70W-pecl-apcu \
  php70W-pecl-memcache \
  php70W-tidy \
  php70W-xml \
  php70W-xmlrpc

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
COPY conf.d /etc/httpd/conf.d

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
