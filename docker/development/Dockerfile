FROM ubuntu:16.04

ENV php_conf /etc/php/7.0/fpm/php.ini
ENV fpm_conf /etc/php/7.0/fpm/php-fpm.conf

RUN apt-get update && apt-get install -y software-properties-common python-software-properties

RUN apt-add-repository ppa:phalcon/stable && apt-get update

RUN apt-get install -y bash \
    openssh-client \
    wget \
    nginx \
    supervisor \
    curl \
    git \
    php7.0-dev \
    php7.0-fpm \
    php7.0-mcrypt \
    php7.0-ctype \
    php7.0-gd \
    php7.0-intl \
    php7.0-xml \
    php7.0-xsl \
    php7.0-curl \
    php7.0-iconv \
    php7.0-json \
    php7.0-phar \
    php7.0-dom \
    php7.0-phalcon \
    php-xdebug \
    ca-certificates \
    dialog \
    gcc \
    musl-dev \
    libffi-dev &&\
    mkdir -p /etc/nginx && \
    mkdir -p /var/www/app && \
    mkdir -p /run/nginx && \
    mkdir -p /var/log/supervisor

    ENV COMPOSER_ALLOW_SUPERUSER 1
    ENV COMPOSER_HOME /tmp
    ENV COMPOSER_VERSION 1.7.2

    RUN curl --silent --fail --location --retry 3 --output /tmp/installer.php --url https://raw.githubusercontent.com/composer/getcomposer.org/b107d959a5924af895807021fcef4ffec5a76aa9/web/installer \
     && php -r " \
        \$signature = '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061'; \
        \$hash = hash('SHA384', file_get_contents('/tmp/installer.php')); \
        if (!hash_equals(\$signature, \$hash)) { \
            unlink('/tmp/installer.php'); \
            echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
            exit(1); \
        }" \
     && php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION} \
     && composer --ansi --version --no-interaction \
     && rm -rf /tmp/* /tmp/.htaccess

# nginx site conf
RUN mkdir -p /etc/nginx/sites-available/ && \
    mkdir -p /etc/nginx/sites-enabled/ && \
    mkdir -p /etc/nginx/ssl/ && \
    rm -Rf /var/www/*
RUN ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

# tweak php-fpm config
RUN mkdir -p /run/php &&\
    sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" ${php_conf} && \
    sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" ${php_conf} && \
    sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" ${php_conf} && \
    sed -i -e "s/variables_order = \"GPCS\"/variables_order = \"EGPCS\"/g" ${php_conf} && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" ${fpm_conf} && \
    sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" ${fpm_conf} && \
    sed -i -e "s/pm.max_children = 4/pm.max_children = 4/g" ${fpm_conf} && \
    sed -i -e "s/pm.start_servers = 2/pm.start_servers = 3/g" /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g" /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g" /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_requests = 500/pm.max_requests = 200/g" /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i -e "s/user = nobody/user = nginx/g" /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i -e "s/group = nobody/group = nginx/g" /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i -e "s/;listen.mode = 0660/listen.mode = 0666/g" /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i -e "s/;listen.owner = nobody/listen.owner = nginx/g" /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i -e "s/;listen.group = nobody/listen.group = nginx/g" /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i -e "s/listen = 127.0.0.1:9000/listen = \/run\/php\/php7.0-fpm.sock/g" /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i -e "s/^;clear_env = no$/clear_env = no/" /etc/php/7.0/fpm/pool.d/www.conf &&\
    ln -s /etc/php/7.0/fpm/php.ini /etc/php/7.0/fpm/conf.d/php.ini && \
    find /etc/php/7.0/fpm/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \; && \
    echo "extension=phalcon.so" > /etc/php/7.0/fpm/conf.d/30-phalcon.ini && \
    echo "extension=phalcon.so" > /etc/php/7.0/cli/conf.d/30-phalcon.ini

RUN apt-get install -y php-pear libcurl4-openssl-dev pkg-config libssl-dev libsslcommon2-dev && \
    pecl install mongodb && \
    echo "extension=mongodb.so" > /etc/php/7.0/fpm/conf.d/30-mongo.ini && \
    echo "extension=mongodb.so" > /etc/php/7.0/cli/conf.d/30-mongo.ini

RUN apt-get install -y memcached php-memcached

# Add Scripts
ADD scripts/start.sh /start.sh
RUN chmod 755 /start.sh

# Copy our nginx config
RUN rm -Rf /etc/nginx/nginx.conf
ADD conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/vhost.conf /etc/nginx/sites-enabled/default

# Services
ADD conf/supervisord.conf /etc/supervisord.conf

EXPOSE 443 80

CMD ["/start.sh"]
