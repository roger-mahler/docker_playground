#!/bin/bash

adduser $PUSER --uid $PUID --gid $PGID --disabled-password --gecos '' --shell /bin/bash

adduser $PUSER sudo

echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

mkdir -p $HOME/work

# chown -R ${PUID}:${PGID} ${HOME}

# find "$HOME" ! \( -group $PGID -a -perm -g+rwX \) -exec chgrp $PGID {} \; -exec chmod g+rwX {} \;
# find "$HOME"   \( -type d -a ! -perm -6000 \)     -exec chmod +6000 {} \;
