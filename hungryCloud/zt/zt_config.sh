#!/usr/bin/bash

{ 
  sleep 5

  /usr/local/bin/retry 'zerotier-cli join $NETWORK_ID'

  sleep 3

  read NODE_ID <<< $(zerotier-cli info | awk '{ print $3}'); export NODE_ID

  echo "NODE_ID: $NODE_ID"

  /usr/local/bin/retry $'curl -X POST https://my.zerotier.com/api/network/$NETWORK_ID/member/$NODE_ID \
      -H "Authorization: Bearer $API_TOKEN" \
      -H "Content-Type: application/json" \
      --data \' { "name": "server", "config": { "authorized" : true } } \''

  sleep 3

  read ZT_IP <<< $(zerotier-cli listnetworks | \
      awk -F '[\/ ]+' '$9 !~ /<ZT/ { print $9 }'); export ZT_IP

  echo "ZT_IP: $ZT_IP"
  
  /usr/local/bin/retry 'docker exec hungrycloud_app_1 sudo -u www-data php occ \
         config:system:set \
         trusted_domains 2 --value=$ZT_IP'
} &

exec zerotier-one
