FROM php:8.2-cli

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       git \
       curl \
       ca-certificates \
       gnupg \
       zip \
       unzip \
       rsync \
       build-essential \
       libzip-dev \
       libpng-dev \
       libonig-dev \
       libxml2-dev \
    && docker-php-ext-install pdo pdo_mysql zip mbstring exif pcntl bcmath xml gd \
    && rm -rf /var/lib/apt/lists/*;

# Install Node.js LTS (NodeSource) so npm and build tools are available inside the container
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get update \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*;

# Install composer from the official image
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Create app directory
WORKDIR /var/www/html

# Copy entrypoint script
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENV COMPOSER_ALLOW_SUPERUSER=1

CMD ["/usr/local/bin/entrypoint.sh"]

# Optional: install Xdebug for code coverage and debugging in dev/CI
# We install via PECL and enable the extension. Default INI values are written
# here but can be overridden at runtime via environment variables such as
# XDEBUG_MODE and XDEBUG_CONFIG (the latter is read by Xdebug and can contain
# client_host/client_port overrides). For example docker-compose sets
# XDEBUG_MODE and XDEBUG_CONFIG where appropriate.
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    || true

# Write a small default Xdebug config file. This provides sensible defaults
# for development. You can override client_host/client_port by setting
# XDEBUG_CONFIG in docker-compose (e.g. client_host=host.docker.internal client_port=9999).
RUN { \
            # docker-php-ext-enable already writes the zend_extension line; avoid hard-coding
            # a path that depends on the PHP API/version. Only write Xdebug config values
            # that are safe as defaults and can be overridden via environment variables
            # (XDEBUG_MODE, XDEBUG_CONFIG) at runtime from docker-compose.
            echo 'xdebug.mode="debug,coverage"'; \
            echo 'xdebug.start_with_request=yes'; \
            echo 'xdebug.client_host=host.docker.internal'; \
            # Use the Xdebug 3 default port (9003) here. Override with XDEBUG_CONFIG if
            # your host IDE listens on a different port (e.g. 9999).
            echo 'xdebug.client_port=9090'; \
            echo 'xdebug.log=/tmp/xdebug_remote.log'; \
            echo 'xdebug.idekey="VSCODE"'; \
        } >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini || true

# Expose the default Xdebug port inside the container. This is informational —
# Xdebug initiates outbound connections to the host IDE and does not require
# a host->container port mapping to work. Map host port to this container port
# in docker-compose if you prefer a different host-side listener port.
EXPOSE 9090
