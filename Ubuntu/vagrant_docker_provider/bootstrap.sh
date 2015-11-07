#!/usr/bin/env bash

# Install the latest Docker.io pacakges and configure the symlinks
apt-get update
# apt-get install -y apache2
apt-get install docker.io
ln -sf /usr/bin/docker.io /usr/local/bin/docker
sed -i '$acomplete -F _docker docker' /etc/bash_completion.d/docker.io