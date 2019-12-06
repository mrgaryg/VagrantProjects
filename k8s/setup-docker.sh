#!/bin/bash
# script that runs
# https://kubernetes.io/docs/setup/production-environment/container-runtime

function sysCtlCMD ()
# Calls systemctl  to perform tasks
{
  local procName=$1
  local sysCMD=$2
}

function svcIsActive()
# Confirm if the serivce is active and activate if it isn't
{
  procName=$1
  systemctl is-active --quiet $procName || systemctl start $procName
}

function svcIsEnabled()
# Confirm if the serivce is enabled and enable if it isn't
{
  procName=$1
  systemctl is-active --quiet $procName || systemctl enable $procName
}

yum update -y
yum install -y vim yum-utils device-mapper-persistent-data lvm2

# Add docker repository
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# notice that only verified versions of Docker may be installed
# verify the documentation to check if a more recent version is available

yum install -y docker-ce
[ ! -d /etc/docker ] && mkdir /etc/docker

echo "Create docker group..."
groupadd -f docker
echo "Adding users to docker group..."
usermod -aG docker vagrant

cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF

echo "Creating docker.service.d directory..."
[ ! -d /etc/systemd/system/docker.service.d ] && mkdir -p /etc/systemd/system/docker.service.d

echo "Enable and start docker daemon..."
systemctl daemon-reload
# systemctl restart docker
# systemctl enable docker
svcIsActive docker
svcIsEnabled docker

if [[ $HOSTNAME = master ]]
then
  echo "Update firewalld rules..."
  svcIsActive "firewalld"

  firewall-cmd --add-port 6443/tcp --permanent
  firewall-cmd --add-port 2379-2380/tcp --permanent
  firewall-cmd --add-port 10250/tcp --permanent
  firewall-cmd --add-port 10251/tcp --permanent
  firewall-cmd --add-port 10252/tcp --permanent
fi

if echo $HOSTNAME | grep worker
then
  svcIsActive "firewalld"
  firewall-cmd --add-port 10250/tcp --permanent
  firewall-cmd --add-port 30000-32767/tcp --permanent
fi

echo "Setup firewalld and rules..."
svcIsEnabled firewalld
echo "Restart firewalld..."
svcIsActive firewalld
echo "${0##*/}: DONE!!!"