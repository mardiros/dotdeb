#!/bin/bash

if [ ! -e /root/.gnupg ]; then
  gpg --batch --gen-key /etc/gen-key-script
fi

exec "$@"

