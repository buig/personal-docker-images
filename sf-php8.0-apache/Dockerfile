FROM php:8.0-apache

# PHP CONFIGURATION
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN echo "memory_limit=-1" > /usr/local/etc/php/conf.d/memory-limit-php.ini
RUN echo "date.timezone=Europe/Madrid" > /usr/local/etc/php/conf.d/timezone.ini

# CONFIGURAR APT: reintentos y timeouts para builds más resilientes
RUN echo 'Acquire::Retries "5";' > /etc/apt/apt.conf.d/80-retries && \
    echo 'Acquire::http::Timeout "120";' >> /etc/apt/apt.conf.d/80-retries && \
    echo 'Acquire::https::Timeout "120";' >> /etc/apt/apt.conf.d/80-retries

# UBUNTU PACKAGES INSTALLATION
RUN apt-get update && apt-get install --no-install-recommends -y \
    tmux \
    vim \
    git \
    unzip \
    zlib1g-dev \
    libpng-dev \
    libzip-dev \
    libxml2-dev \
    libicu-dev \
    python3 \
    python3-pip \
    python3-venv \
    wget \
    curl \
    xz-utils \
    libxrender1 \
    libxext6 \
    libfontconfig1 \
    libx11-6 \
    libxcb1 \
    default-mysql-client \
    npm \
    pdftk \
    cron \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

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
# PYTHON LIBRARIES INSTALLATION
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install mysql-connector

# Añadir el venv al PATH para que los scripts usen automáticamente el python del venv
ENV PATH="/opt/venv/bin:$PATH"

# COMPOSER INSTALLATION FOR PHP DEPENDENCIES
RUN curl -o composer-setup.php https://getcomposer.org/installer && \
    curl -o composer-setup.sig https://composer.github.io/installer.sig && \
    php -r "if (hash('SHA384', file_get_contents('composer-setup.php')) !== trim(file_get_contents('composer-setup.sig'))) { unlink('composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" && \
    php composer-setup.php --version=2.6.2 --quiet && \
    mv composer.phar /usr/local/bin/composer && \
    rm -f composer-setup.php composer-setup.sig

# INSTALLING WKHTMLTOPDF - multi-arch + multi-distro compatible
ARG TARGETARCH

RUN set -eux; \
    apt-get update; \
    DEBIAN_VERSION=$(. /etc/os-release && echo "$VERSION_CODENAME"); \
    echo "Detectada arquitectura: $TARGETARCH, distro: $DEBIAN_VERSION"; \
    if [ "$TARGETARCH" = "amd64" ]; then \
    wget -q "https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.${DEBIAN_VERSION}_amd64.deb" \
    -O /tmp/wkhtmltox.deb && \
    apt-get install -y --no-install-recommends /tmp/wkhtmltox.deb && \
    rm /tmp/wkhtmltox.deb; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
    apt-get install -y --no-install-recommends wkhtmltopdf; \
    else \
    echo "Arquitectura no soportada: $TARGETARCH" && exit 1; \
    fi; \
    rm -rf /var/lib/apt/lists/*

# Verificar instalación
RUN wkhtmltopdf --version

# WORKING DIRECTORY
WORKDIR /code

# APACHE CONFIGURATION
RUN a2enmod rewrite headers

EXPOSE 80

COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV TZ=Europe/Madrid

ENTRYPOINT ["/entrypoint.sh"]
