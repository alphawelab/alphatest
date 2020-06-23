#!/bin/bash
set -e

printf "\n\033[0;44m---> Creating SSH master user.\033[0m\n"

# Create user if not existed
if ! id -u ${SSH_USER} > /dev/null 2>&1 ; then
    useradd -m -G sftp ${SSH_USER} -s /usr/sbin/nologin
    echo 'PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin"' >> /home/${SSH_USER}/.profile
    mkdir -p /opt/${SSH_USER}/upload
    chown ${SSH_USER}:${SSH_USER} /opt/${SSH_USER}/upload
    chmod 700 /opt
fi 

# Check if ssh password exist if ssh password authen is enabled
if [ ! "${SSH_PASS}" ] && ! grep "PasswordAuthentication no" /etc/ssh/sshd_config >/dev/null ; then
    echo "Environment Variable SSH_PASS is missing!" 1>&2
    exit 1
fi 

# Add user password
if [ "${SSH_PASS}" ]; then 
    echo "${SSH_USER}:${SSH_PASS}" | chpasswd
fi

# Check if RSA_PUB_KEY is provided
if [ ! "${RSA_PUB_KEY}" ] && grep "PasswordAuthentication no" /etc/ssh/sshd_config >/dev/null ; then
    echo "Environment Variable RSA_PUB_KEY is missing!" 1>&2
    exit 1
fi 

# Add public key to %HOME/.ssh/authorized_keys
if [ "${RSA_PUB_KEY}" ]; then 

    # Add random password to user
    if [ ! "${SSH_PASS}" ]; then 
        password=`tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1`
        echo "${SSH_USER}:${password}" | chpasswd
    fi
    
    mkdir /home/${SSH_USER}/.ssh
    chmod 700 /home/${SSH_USER}/.ssh
    chown ${SSH_USER}:${SSH_USER} /home/${SSH_USER}/.ssh
    echo "${RSA_PUB_KEY}" >> "/home/${SSH_USER}/.ssh/authorized_keys"
    chown ${SSH_USER}:${SSH_USER} "/home/${SSH_USER}/.ssh/authorized_keys"
    chmod 600 "/home/${SSH_USER}/.ssh/authorized_keys"
fi

exec "$@"