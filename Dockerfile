FROM ubuntu:16.04
LABEL Description="Ubuntu for Bitbucket Pipelines CI/CD" \
    Maintainer="Hendrik Prinsloo <hendrik.prinsloo@clevva.com>"\
	License="Apache License 2.0" \
	Version="1.0"

ENV DEBIAN_FRONTEND noninteractive

# Classic update & upgrade
RUN apt-get update
RUN apt-get upgrade -y

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

# Install PHP & modules
RUN apt-get -y --no-install-recommends install \
	php7.0 \
	php7.0-bcmath \
	php7.0-bz2 \
	php7.0-cgi \
	php7.0-cli \
	php7.0-common \
	php7.0-curl \
	php7.0-dev \
	php7.0-enchant \
	php7.0-fpm \
	php7.0-gd \
	php7.0-gmp \
	php7.0-imap \
	php7.0-interbase \
	php7.0-intl \
	php7.0-json \
	php7.0-ldap \
	php7.0-mbstring \
	php7.0-mcrypt \
	php7.0-mysql \
	php7.0-odbc \
	php7.0-opcache \
	php7.0-pgsql \
	php7.0-phpdbg \
	php7.0-pspell \
	php7.0-readline \
	php7.0-recode \
	php7.0-sqlite3 \
	php7.0-sybase \
	php7.0-tidy \
	php7.0-xmlrpc \
	php7.0-xsl \
	php7.0-zip

# Composer & PHPUnit
RUN \
	curl -sSL https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/bin &&\
	curl -sSL https://phar.phpunit.de/phpunit-5.7.phar -o /usr/bin/phpunit  && chmod +x /usr/bin/phpunit  &&\
	curl -sSL http://codeception.com/codecept.phar -o /usr/bin/codecept && chmod +x /usr/bin/codecept &&\
	npm install --no-color --production --global gulp-cli webpack mocha grunt clean-css-cli uglify-js &&\
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
