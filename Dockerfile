FROM debian:10-slim

ARG PasswordAuth
ENV PasswordAuth false

RUN apt-get update && \
    apt-get -y install openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/sshd
    # rm -f /etc/ssh/ssh_host_*key*

# RUN ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N '' && \
#     ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N '' && \
#     ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''

COPY ssh_config /etc/ssh/ssh_config
COPY sshd_config /etc/ssh/sshd_config

RUN if [ "$PasswordAuth" = "false" ]; then \
        echo "PasswordAuthentication no" >> /etc/ssh/sshd_config; \
    fi

RUN groupadd sftp

COPY user.sh /usr/local/bin/user.sh
RUN chmod +x /usr/local/bin/user.sh

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/usr/sbin/sshd", "-D", "-e"]