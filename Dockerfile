FROM ubuntu:16.04
LABEL Description="Ubuntu for Bitbucket Pipelines CI/CD" \
    Maintainer="Hendrik Prinsloo <hendrik.prinsloo@clevva.com>"\
	License="Apache License 2.0" \
	Version="1.0"

ENV DEBIAN_FRONTEND noninteractive

# Classic update & upgrade
RUN apt-get update && apt-get upgrade -y

# Install some common packages
RUN apt-get -y --no-install-recommends install \
	apt-utils \
	rsync \
	zip \
	unzip \
	git \
	composer \
	nano \
	tree \
	vim \
	curl \
	ftp \
	openssh-client \
	software-properties-common \
	mysql-client \
	apt-transport-https \
	ruby \
	python \
	python3 \
	perl \
	wget

# Node & npm
RUN apt-get update && \
	apt-get install -y --no-install-recommends curl && \
	curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
	apt-get install -y nodejs

# Update
RUN apt-get update

# PHP
## Remove all the stock php packages
RUN apt-get purge -y `dpkg -l | grep php| awk '{print $2}' |tr "\n" " "`

## Add the PPA
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php

## Install
RUN apt-get update && apt-get install -y php7.2

## Modules - install
RUN apt-get install -y \
    php7.2-bcmath \
    php7.2-bz2 \
    php7.2-cgi \
    php7.2-cli \
    php7.2-common \
    php7.2-curl \
    php7.2-dev \
    php7.2-enchant \
    php7.2-fpm \
    php7.2-gd \
    php7.2-gmp \
    php7.2-imap \
    php7.2-interbase \
    php7.2-intl \
    php7.2-json \
    php7.2-ldap \
    php7.2-mbstring \
    php7.2-mysql \
    php7.2-odbc \
    php7.2-opcache \
    php7.2-pgsql \
    php7.2-phpdbg \
    php7.2-pspell \
    php7.2-readline \
    php7.2-snmp \
    php7.2-sqlite3 \
    php7.2-sybase \
    php7.2-tidy \
    php7.2-xmlrpc \
    php7.2-xsl \
    php7.2-zip \
    php7.2-xdebug

# Composer & PHPUnit
RUN \
	curl -sSL https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/bin &&\
	curl -sSL https://phar.phpunit.de/phpunit-5.7.phar -o /usr/bin/phpunit  && chmod +x /usr/bin/phpunit  &&\
	curl -sSL http://codeception.com/codecept.phar -o /usr/bin/codecept && chmod +x /usr/bin/codecept &&\
	npm install --no-color --production --global gulp-cli webpack mocha grunt clean-css-cli uglify-js vuepress &&\
	rm -rf /root/.npm /root/.composer /tmp/* /var/lib/apt/lists/*

# JRE
RUN set -x \
    && apt-get update -qy \
    && apt-get install --no-install-recommends -qfy default-jre build-essential \
    && apt-get clean

RUN curl -o /cmd.run.zip http://cdn.sencha.com/cmd/6.5.3.6/no-jre/SenchaCmd-6.5.3.6-linux-amd64.sh.zip && \
    unzip -p /cmd.run.zip > /cmd-install.run && \
    chmod +x /cmd-install.run && \
    /cmd-install.run -q -dir /opt/Sencha/Cmd/6.5.3.6 && \
    rm /cmd-install.run /cmd.run.zip

ENV PATH="/opt/Sencha/Cmd:$PATH"

# Clean & autoremove
RUN apt-get autoclean && apt-get clean && apt-get autoremove

# Initiate
COPY initiate.sh /usr/sbin/
RUN chmod +x /usr/sbin/initiate.sh

CMD ["/usr/sbin/initiate.sh"]
