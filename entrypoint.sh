#!/bin/bash

if [ ! -e /root/.gnupg ]; then
  gpg --batch --gen-key /etc/gen-key-script
  gpg --export --armor > /root/gpg.key
fi

apt-key add /root/gpg.key
apt-get update

exec "$@"

