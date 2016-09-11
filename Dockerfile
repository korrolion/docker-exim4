FROM debian:jessie

MAINTAINER Igor Korolev "ik.pr@bk.ru"

RUN apt-get update && \
    apt-get install -y exim4-daemon-light && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    find /var/log -type f | while read f; do echo -ne '' > $f; done;

COPY 00_local_macros /etc/exim4/conf.d/main/
COPY entrypoint.sh /bin/

RUN chmod a+x /bin/entrypoint.sh

EXPOSE 25
ENTRYPOINT ["/bin/entrypoint.sh"]
