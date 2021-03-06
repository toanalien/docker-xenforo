# docker pull xfrocks/xenforo
Docker containers to develop and run XenForo.

Installed extensions (other than the default ones):
 * apcu
 * exif
 * gd
 * gmp
 * imagick (php-apache only)
 * memcached
 * mysqli
 * opcache
 * pcntl
 * redis
 * soap
 * sockets
 * tideways (php-fpm only, with `auto_start=0` `auto_prepend_library=0`)
 * xdebug (installed but disabled on php-fpm)
 * zip

List of all extensions on php-fpm (according to `php -m`):
apcu
Core
ctype
curl
date
dom
exif
fileinfo
filter
ftp
gd
gmp
hash
iconv
igbinary
json
libxml
mbstring
memcached
mysqli
mysqlnd
openssl
pcntl
pcre
PDO
pdo_sqlite
Phar
posix
readline
redis
Reflection
session
SimpleXML
soap
sockets
sodium
SPL
sqlite3
standard
tideways
tokenizer
xml
xmlreader
xmlwriter
Zend OPcache
zip
zlib
Zend OPcache

## Development
Sample `docker-compose.yml`:

```
version: '2'

services:
  php:
    image: xfrocks/xenforo:php-apache
    environment:
      - VIRTUAL_HOST=dev.local.xfrocks.com
    expose:
      - "80"
    links:
      - mysql
    volumes:
      - .:/var/www/html/

  mysql:
    image: mysql
    environment:
      MYSQL_RANDOM_ROOT_PASSWORD: 'yes'
      MYSQL_DATABASE: 'database'
      MYSQL_USER: 'user'
      MYSQL_PASSWORD: 'password'
    expose:
      - "3306"
    volumes:
      - ./internal_data/mysql:/var/lib/mysql

  nginx-proxy:
    image: jwilder/nginx-proxy
    ports:
      - "80:80"
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
```

### Friendly URLs

The apache image doesn't have mod_rewrite enabled, use FallbackResource in `.htaccess` if you need XenForo's friendly URLs:

```
FallbackResource /index.php
```

## Production
It's recommended to use the fpm image with nginx for better performance in production.
