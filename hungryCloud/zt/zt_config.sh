#!/usr/bin/bash

{ 
  sleep 5
  zerotier-cli join 12ac4a1e7166f279
} &
exec zerotier-one