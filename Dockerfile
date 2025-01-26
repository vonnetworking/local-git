FROM ubuntu:25.04

RUN apt-get update -y && \
    apt-get install -y git python3 python3-pip lighttpd gitweb

RUN useradd -u 501 git && \
    mkdir /usr/local/git && \
    chown git:root /usr/local/git && \
    mkdir -p /home/git/scm && \
    mkdir -p /home/git/conf && \
    mkdir -p /home/git/scripts && \
    git config --global init.defaultBranch main

COPY lighttpd.conf /home/git/conf/lighttpd.conf
COPY gitweb.conf /home/git/conf/gitweb.conf
COPY repo_maker.sh /home/git/scripts/repo_maker.sh
COPY www /home/git/www

COPY lighttpd.conf /home/git/conf/lighttpd.conf
COPY gitweb.conf /home/git/conf/gitweb.conf
COPY repo_maker.sh /home/git/scripts/repo_maker.sh
COPY bootstrap.sh /home/git/scripts/bootstrap.sh
COPY www /home/git/www

RUN lighty-enable-mod cgi && \
    lighty-enable-mod auth && \
    lighty-enable-mod setenv && \
    chown -R git:root /home/git/scripts && \
    chown -R git:root /home/git/conf && \
    chown -R git:root /home/git/scm && \
    chown -R git:root /home/git/www && \
    chmod 660 /home/git/conf/lighttpd.conf && \
    chmod 644 /home/git/www/* && \
    chmod 754 /home/git/scripts/*.sh

ENV REPO_DIR=/home/git/scm
ENV REPO_NAME_LENGTH=6
ENV REPO_PASS_LENGTH=8
ENV HTTP_CONFIG_FILE=/home/git/conf/lighttpd.conf
ENV PROTECT=false
ENV RESPONSE_FORMAT=json
ENV REPO_URL_BASE=""

USER git

CMD ["/home/git/scripts/bootstrap.sh"]