#!/usr/bin/env bash

# $1: space separated list of services to check for
function checkss {
  IFS=" "
  WAITING_FOR=""
  SERVICES=`cedarss`
  for s in $1; do
    if [[ (`echo "$SERVICES" | sed -n "s/\($s \)/\1/p"` =~ "Stopped") ]]; then
      WAITING_FOR="$WAITING_FOR $s"
    fi
  done
}

#for i in {1..50}; do
#  WAITING_FOR=""
#  SERVICES=`cedarss`
#  if [[ (`echo "$SERVICES" | sed -n 's/\(MongoDB\)/\1/p'` =~ "Stopped") ]]; then
#    WAITING_FOR="$WAITING_FOR MongoDB"
#  fi
#  if [[ (`echo "$SERVICES" | sed -n 's/\(Elasticsearch-REST\)/\1/p'` =~ "Stopped") ]]; then
#    WAITING_FOR="$WAITING_FOR Elasticsearch-REST"
#  fi
#  if [[ (`echo "$SERVICES" | sed -n 's/\(Elasticsearch-Transport\)/\1/p'` =~ "Stopped") ]]; then
#    WAITING_FOR="$WAITING_FOR Elasticsearch-Transport"
#  fi
#  if [[ (`echo "$SERVICES" | sed -n 's/\(NGINX\)/\1/p'` =~ "Stopped") ]]; then
#    WAITING_FOR="$WAITING_FOR NGINX"
#  fi
#  if [[ (`echo "$SERVICES" | sed -n 's/\(Keycloak\)/\1/p'` =~ "Stopped") ]]; then
#    WAITING_FOR="$WAITING_FOR Keycloak"
#  fi
#  if [[ (`echo "$SERVICES" | sed -n 's/\(Neo4j\)/\1/p'` =~ "Stopped") ]]; then
#    WAITING_FOR="$WAITING_FOR Neo4j"
#  fi
#  if [[ (`echo "$SERVICES" | sed -n 's/\(Redis-persistent\)/\1/p'` =~ "Stopped") ]]; then
#    WAITING_FOR="$WAITING_FOR Redis-persistent"
#  fi
#  if [[ (`echo "$SERVICES" | sed -n 's/\(MySQL\)/\1/p'` =~ "Stopped") ]]; then
#    WAITING_FOR="$WAITING_FOR MySQL"
#  fi
#
#  if [[ $WAITING_FOR == "" ]]
#  then
#    echo "+++++ All up and running!"
#    break
#  else
#    echo "+++++ Waiting for: $WAITING_FOR ($i/50)"
#  fi
#  sleep 3
#done