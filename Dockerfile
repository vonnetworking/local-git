FROM ubuntu:25.04


RUN apt-get update -y && \
    apt-get install -y git python3 python3-pip lighttpd && \
    adduser git && \
    mkdir /usr/local/git && \
    chown git:git /usr/local/git && \
    mkdir -p /home/git/scm && \
    mkdir -p /home/git/conf && \
    mkdir -p /home/git/scripts && \
    git config --global init.defaultBranch main

# Optional packages - exclude from prod deploy     
RUN apt-get install net-tools

COPY lighttpd.conf /home/git/conf/lighttpd.conf
COPY repo_maker.sh /home/git/scripts/repo_maker.sh

RUN lighty-enable-mod cgi && \
    lighty-enable-mod auth && \
    lighty-enable-mod setenv && \
    chmod 444 /home/git/conf/lighttpd.conf && \
    chmod 754 /home/git/scripts/repo_maker.sh

ENV REPO_DIR=/home/git/scm
ENV REPO_NAME_LENGTH=6
ENV REPO_PASS_LENGTH=8
ENV HTTP_CONFIG_FILE=/home/git/conf/lighttpd.conf
ENV PROTECT=false
ENV RESPONSE_FORMAT=text
ENV REPO_URL_BASE=""

CMD ["/usr/sbin/lighttpd", "-f", "/home/git/conf/lighttpd.conf", "-D"]