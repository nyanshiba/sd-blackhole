#!/bin/bash

server=ospf.igo
if [ "$1" == "" ]; then
  daemons="frr import-drop"
else
  daemons=$@
fi

rsync -rtv \
  --exclude='.git/' \
  --include='*/' \
  --include='frr/***' \
  --include='sysctl.d/***' \
  --include='systemd/network/***' \
  --include='systemd/system/***' \
  --exclude='*' \
  . "$server:/etc/"

ssh -t $server "systemctl daemon-reload; systemctl restart $daemons; sleep 1; echo $daemons: \$(systemctl is-active $daemons)"
