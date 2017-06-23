#!/bin/sh

set -e

case "${ELASTICSEARCH_TLS}:${ELASTICSEARCH_TLS_VERIFY}" in
  true:true)
    WGET_SCHEMA='https://'
    CREATE_EA_OPTIONS='--ssl --verify-certs'
  ;;
  true:false)
    WGET_SCHEMA='https://'
    CREATE_EA_OPTIONS='--ssl --no-verify-certs'
  ;;
  *)
    WGET_SCHEMA='http://'
    CREATE_EA_OPTIONS='--no-ssl'
  ;;
esac

ntpd -s

exec supervisord -c /opt/elastalert/supervisord.conf -n
