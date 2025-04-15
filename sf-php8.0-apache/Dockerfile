FROM php:8.0-apache

# PHP CONFIGURATION
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN echo "memory_limit=-1" > /usr/local/etc/php/conf.d/memory-limit-php.ini

# UBUNTU PACKAGES INSTALLATION
RUN apt-get update && apt-get install --no-install-recommends -y tmux \
    vim \
    git \
    unzip \
    tmux \
    zlib1g-dev \
    libpng-dev \
    libzip-dev \
    libxml2-dev \
    python3 \
    python3-pip \
    wget \
    libxrender1 \
    libxext6 \
    libfontconfig1 \
    default-mysql-client \
    npm \
    pdftk \
    cron

# UPDATE NPM TO LATEST
RUN npm cache clean -f && npm install -g n && n stable

# PHP EXTENSIONS INSTALLATION
RUN docker-php-ext-install pcntl \
    zip \
    gd \
    xml \
    intl \
    fileinfo

RUN docker-php-ext-install pdo pdo_mysql
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

# PYTHON LIBRARIES INSTALLATION
RUN pip3 install mysql-connector

# COMPOSER INSTALLATION FOR PHP DEPENDACIES
RUN curl -o composer-setup.php https://getcomposer.org/installer && \
    curl -o composer-setup.sig https://composer.github.io/installer.sig && \
    php -r "if (hash('SHA384', file_get_contents('composer-setup.php')) !== trim(file_get_contents('composer-setup.sig'))) { unlink('composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" && \
    php composer-setup.php --version=2.6.2 --quiet && \
    mv composer.phar /usr/local/bin/composer

# INSTALLING LIBRARY FOR PDF
RUN cd /tmp/ && \
    wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz && \
    tar xvf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz && \
    mv wkhtmltox/bin/wkhtmlto* /usr/bin/ && \
    ln -nfs /usr/bin/wkhtmltopdf /usr/local/bin/wkhtmltopdf && \
    rm -r wkhtmltox wkhtmltox-0.12.4_linux-generic-amd64.tar.xz

# CLEAN IMAGE
RUN apt purge --auto-remove && apt clean && rm -rf /var/lib/apt/lists/*

#WORKING DIRECTORY
WORKDIR /code

#APACHE CONFIGURATION
RUN a2enmod rewrite headers

EXPOSE 80:80

COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
