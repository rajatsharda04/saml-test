#Use Apache version of PHP as Docker base image
FROM php:7.2-apache

#Install Dependecies (Debian Base Image)
RUN apt-get update -y && apt-get install -y libgmp-dev re2c libmhash-dev file nano zip unzip wget vim

#Enable/Install PHP extension using php-docker helper scripts - https://hub.docker.com/_/php/
RUN docker-php-ext-install pdo_mysql
RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/local/include/
RUN docker-php-ext-configure gmp && docker-php-ext-install gmp


# Disabling Apache version header & Php header
RUN sed -i "/ServerTokens OS/c\ServerTokens Prod" /etc/apache2/conf-enabled/security.conf && sed -i "/ServerSignature On/c\ServerSignature Off" /etc/apache2/conf-enabled/security.conf
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
RUN sed -i "/expose_php/c\expose_php = Off" /usr/local/etc/php/php.ini

RUN cp /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/ && \
    cp /etc/apache2/mods-available/headers.load /etc/apache2/mods-enabled/

ADD configure-mksaml.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/configure-mksaml.sh

# use configure-mksaml.sh as entry point for the docker -- Gets executed when docker starts
ENTRYPOINT ["configure-mksaml.sh"]
