#!/bin/sh

if [ ! -z x$CONFIGURE_HELM ]; then
  . /usr/bin/configure-helm.sh
  configure_helm
fi

exec ./start.sh


