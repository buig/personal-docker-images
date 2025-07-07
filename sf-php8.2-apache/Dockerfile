FROM php:8.2-apache

# PHP CONFIGURATION
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN echo "memory_limit=-1" > /usr/local/etc/php/conf.d/memory-limit-php.ini

RUN dpkg --add-architecture amd64 \
 && apt-get update \
 && apt-get install --no-install-recommends -y \
      libc6:amd64 libstdc++6:amd64 \
      libxrender1:amd64 libxext6:amd64 libfontconfig1:amd64

# UBUNTU PACKAGES INSTALLATION
RUN apt-get update && apt-get install --no-install-recommends -y \
    libjpeg-dev \
    libpng-dev \
    libzip-dev \
    libxml2-dev \
    zlib1g-dev \
    vim git unzip tmux python3 python3-pip wget \
    libxrender1 libxext6 libfontconfig1 default-mysql-client npm

# ACTUALIZAR NPM
RUN npm cache clean -f && npm install -g n && n stable

# CONFIGURAR Y COMPILAR EXTENSIONES PHP
RUN docker-php-ext-configure gd --with-jpeg
RUN docker-php-ext-install \
    pcntl \
    zip \
    gd \
    xml \
    intl \
    fileinfo \
    pdo \
    pdo_mysql \
    mysqli && \
    docker-php-ext-enable mysqli

# COMPOSER
RUN curl -o composer-setup.php https://getcomposer.org/installer && \
    curl -o composer-setup.sig https://composer.github.io/installer.sig && \
    php -r "if (hash('SHA384', file_get_contents('composer-setup.php')) !== trim(file_get_contents('composer-setup.sig'))) { unlink('composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" && \
    php composer-setup.php --version=2.6.2 --quiet && \
    mv composer.phar /usr/local/bin/composer

# SYMFONY CLI
RUN wget https://get.symfony.com/cli/installer -O - | bash && \
    mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

# INSTALAR WKHTMLTOPDF
RUN cd /tmp/ && \
    wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz && \
    tar xvf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz && \
    mv wkhtmltox/bin/wkhtmlto* /usr/bin/ && \
    ln -nfs /usr/bin/wkhtmltopdf /usr/local/bin/wkhtmltopdf && \
    rm -r wkhtmltox*

# LIMPIEZA
RUN apt-get purge -y --auto-remove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# CONFIGURACIÓN APACHE
RUN a2enmod rewrite headers

# DIRECTORIO DE TRABAJO
WORKDIR /code

EXPOSE 80
