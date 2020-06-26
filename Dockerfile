FROM ubuntu:18.04
RUN apt-get update
RUN apt-get install software-properties-common -y
RUN add-apt-repository ppa:ondrej/php -y
RUN apt-get update
RUN apt-get install php7.3 php7.3-fpm php7.3-mbstring php7.3-mysql php7.3-curl -y
RUN apt-get install php7.3-cli php7.3-fpm php7.3-mysql php7.3-json php7.3-opcache php7.3-mbstring php7.3-xml php7.3-gd php7.3-curl -y
RUN mkdir -p /var/www/html
COPY wp_files/ /var/www/html/
RUN chown -R www-data:www-data /var/www/html
COPY ./php_new_conf/7.3 /etc/php/7.3
EXPOSE 9000
RUN mkdir /data
COPY ./nginx/nginx.conf /data/default.conf
ENTRYPOINT  /bin/bash -c  '/usr/sbin/php-fpm7.3 -c /etc/php/7.3/fpm/php-fpm.conf && tail -f /dev/null'
