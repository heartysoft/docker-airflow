#!/bin/sh

if [ "x$CONFIGURE_HELM" != "x" ]; then
  /usr/bin/configure-helm.sh
fi

exec ./start.sh


