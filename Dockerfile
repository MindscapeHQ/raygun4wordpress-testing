FROM wordpress:cli
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
USER root
RUN apk add --no-cache subversion