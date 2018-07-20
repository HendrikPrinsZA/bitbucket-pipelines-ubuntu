#!/bin/bash

# PHP configs
/bin/sed -i "s/short_open_tag\ \=\ Off/short_open_tag\ \=\ On/g" /etc/php/7.0/cli/php.ini
