#!/bin/bash
HTTP_CONFIG_FILE=${HTTP_CONFIG_FILE:-/home/git/conf/lighttpd.conf}
INDEX_HTML=${INDEX_HTML:-/home/git/www/index.html}

sed -i "s|{{ SITE_URL }}|${SITE_URL}|g" ${HTTP_CONFIG_FILE}

sed -i "s|{{ SITE_URL }}|${SITE_URL}|g" ${INDEX_HTML}

/usr/sbin/lighttpd -f /home/git/conf/lighttpd.conf -D