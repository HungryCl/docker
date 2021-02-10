#!/usr/bin/bash

{ 
  #wait for zeroter-one service to start before joining
  sleep 5

  /usr/local/bin/retry 'zerotier-cli join $NETWORK_ID'

  #wait for join before proceeding
  sleep 3

  #TO DO: use fixed version of zerotier-one
  read NODE_ID <<< $(zerotier-cli info | awk '{ print $3}'); export NODE_ID

  echo "NODE_ID: $NODE_ID"

  #enable node as authorized
  /usr/local/bin/retry $'curl -X POST https://my.zerotier.com/api/network/$NETWORK_ID/member/$NODE_ID \
      -H "Authorization: Bearer $API_TOKEN" \
      -H "Content-Type: application/json" \
      --data \' { "name": "server", "config": { "authorized" : true } } \''

  sleep 3

  #get zerotier IP of node
  read ZT_IP <<< $(zerotier-cli listnetworks | \
      awk -F '[\/ ]+' '$9 !~ /<ZT/ { print $9 }'); export ZT_IP

  echo "ZT_IP: $ZT_IP"
  
  #set trusted domains in nextcloud, retry multiple times as app takes a while to come up
  /usr/local/bin/retry --tries=50 'docker exec hungrycloud_app_1 sudo -u www-data php occ \
         config:system:set \
         trusted_domains 2 --value=$ZT_IP'

  #disable nc apps, add user, and mount external hdd if present
  docker exec hungrycloud_app_1 \
      su -s /bin/sh www-data -c \
      'php occ app:disable password_policy;
       php occ app:disable firstrunwizard;
       php occ app:disable photos;
       php occ app:disable dashboard;
       php occ app:disable activity;
       php occ app:disable files_sharing;
       php occ app:disable nextcloud_announcements;
       php occ app:disable notifications;
       php occ app:disable privacy;
       php occ app:disable user_status;
       php occ app:disable support;
       php occ app:disable contactsinteraction;
       php occ app:disable cloud_federation_api;
       php occ app:disable federation;
       php occ app:disable federatedfilesharing;

       php occ app:enable files_external;
    
       php occ user:add $OC_USER --password-from-env;

       php occ config:system:set skeletondirectory;
       php occ config:system:set knowledgebaseenabled --type=boolean --value=false;

       php occ files_external:verify 1 || php occ files_external:create hdd local null::null -c datadir=/opt/external/root;'

} &

exec zerotier-one
