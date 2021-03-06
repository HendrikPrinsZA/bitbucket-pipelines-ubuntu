[Bitbucket Pipelines](https://bitbucket.org/product/features/pipelines) [Docker](https://www.docker.com/) image based on [Ubuntu](https://hub.docker.com/_/ubuntu/).

## Packages installed
- [Node.js](https://nodejs.org/) `8.11`
- [NPM](https://www.npmjs.com/) `5.6`
  - [Gulp](http://gulpjs.com/), [Webpack](https://webpack.github.io/), [Mocha](https://mochajs.org/), [Grunt](http://gruntjs.com/), [Codeception](https://codeception.com/), [Yarn](https://yarnpkg.com/)
- [Perl](https://www.perl.org/) `5.22`
- [PHP](http://www.php.net/) `7.2`
  - `bcmath`,`bz2`,`cgi`,`cli`,`common`,`curl`,`dev`,`enchant`,`fpm`,`gd`,`gmp`,`imap`,`interbase`,`intl`,`json`,`ldap`,`mbstring`,`mysql`,`odbc`,`opcache`,`pgsql`,`phpdbg`,`pspell`,`readline`,`snmp`,`sqlite3`,`sybase`,`tidy`,`xmlrpc`,`xsl`,`zip`,`xdebug`
- [PHPUnit](https://phpunit.de/) `5.7.27`
- [Python](https://www.python.org/) `2.7`
- [Ruby](https://www.ruby-lang.org/) `2.3`
- [Sencha CMD](http://docs.sencha.com/cmd/) `6.5.3.6`
- [Composer](https://getcomposer.org/) `1.6.5`,
- Other
  - `apt-transport-https`, `bzip2`, `ca-certificates`, `clean-css-cli`, `curl`, `gettext`, `git`, `imagemagick`, `memcached`, `mysql-client`, `openjdk-7-jre`, `openssh-client`, `perl`, `python`, `python3`, `rsync`, `ruby`, `software-properties-common`, `subversion`, `unzip`, `uglify-js`, `wget`, `zip`

## Example - Build the image locally
```SHELL
git clone git@github.com:HendrikPrinsZA/bitbucket-pipelines-ubuntu.git && cd bitbucket-pipelines-ubuntu
docker build . --tag bitbucket-pipelines-ubuntu-local
docker run -it --volume=/var/www/html/project:/project --workdir="/project" --entrypoint=/bin/bash bitbucket-pipelines-ubuntu-local
```

## Example - Remote image
```SHELL
docker run -it --volume=/var/www/html/project:/project --workdir="/project" --entrypoint=/bin/bash hendrikprinsza/bitbucket-pipelines-ubuntu
```

## Example - [Bitbucket Pipelines](https://bitbucket.org/product/features/pipelines)
```YAML
pipelines:
  default:
    - step:
        image: hendrikprinsza/bitbucket-pipelines-ubuntu
        script:
          - phpunit --version
          - mysql -h127.0.0.1 -uroot -pthepassword123 -e "SET GLOBAL sql_mode = 'NO_ENGINE_SUBSTITUTION';"
        services:
          - mysql

definitions:
  services:
    mysql:
      image: mysql:5.6
      environment:
        MYSQL_DATABASE: test_database
        MYSQL_ROOT_PASSWORD: password123
```
