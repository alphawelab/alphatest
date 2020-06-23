#!/bin/bash
set -e
 
printf "\n\033[0;44m---> Starting the SSH server.\033[0m\n"
 
    # Generate unique ssh keys for this container, if needed
    # if [ ! -f /etc/ssh/ssh_host_ed25519_key ]; then
    #     ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ''
    # fi

    # if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    #     ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N ''
    # fi

    # if [ ! -f /etc/ssh/ssh_host_ecdsa_key ]; then
    #     ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''
    # fi

echo "\nCreate SSH User\n"
sh /usr/local/bin/user.sh

chmod 700 /opt

# service ssh start
# service ssh status

exec "$@"