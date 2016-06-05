#!/bin/bash
# Rebuild solution.

zephir fullclean
zephir build

/etc/init.d/php7.0-fpm restart
/etc/init.d/nginx restart
