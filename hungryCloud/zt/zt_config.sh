#!/usr/bin/bash

{ 
  sleep 3

  zerotier-cli join 12ac4a1e7166f279

  sleep 3

  read ZTIP <<< $(zerotier-cli listnetworks | \
      awk -F '[\/ ]+' '$9 !~ /<ZT/ { print $9 }')
  
  docker exec hungrycloud_app_1 sudo -u www-data php occ \
         config:system:set \
         trusted_domains 2 --value=$ZTIP
} &

exec zerotier-one