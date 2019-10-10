FROM alpine
ENV ELASTICSEARCH_TLS false
ENV ELASTICSEARCH_TLS_VERIFY true
WORKDIR /opt
COPY ./start-elastalert.sh /opt/
WORKDIR /opt/elastalert
COPY ./supervisord.conf /opt/elastalert/
RUN pip install elastalert && \
    easy_install supervisor && \
    mkdir -p /var/empty && \
    rm -rf /var/cache/apk/* && \
    supervisord -c /opt/elastalert/supervisord.conf
CMD ["/opt/start-elastalert.sh"]
