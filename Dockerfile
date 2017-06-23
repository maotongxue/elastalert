FROM alpine

ENV ELASTICSEARCH_TLS false
ENV ELASTICSEARCH_TLS_VERIFY true

WORKDIR /opt
COPY ./start-elastalert.sh /opt/
RUN apk update && \
    apk upgrade && \
    apk add ca-certificates curl openssl-dev openssl libffi-dev python2 python2-dev py2-pip py2-yaml gcc musl-dev tzdata openntpd && \
    wget -O elastalert.zip https://github.com/Yelp/elastalert/archive/master.zip && \
    unzip elastalert.zip && \
    rm elastalert.zip && \
    chmod +x /opt/start-elastalert.sh && \
    mv e* elastalert

WORKDIR /opt/elastalert
COPY ./supervisord.conf /opt/elastalert/
RUN python setup.py install && \
    pip install -e . && \
    pip uninstall twilio --yes && \
    pip install twilio==6.0.0 && \

    easy_install supervisor && \
    mkdir -p /var/empty && \
    apk del python2-dev && \
    apk del musl-dev && \
    apk del gcc && \
    apk del openssl-dev && \
    apk del libffi-dev && \
    rm -rf /var/cache/apk/* && \
  
    supervisord -c /opt/elastalert/supervisord.conf

CMD ["/opt/start-elastalert.sh"]
