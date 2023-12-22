#!/usr/bin/env bash

export getBoshCli=0
# set to 0 for boshcli v1
export boshcli2=1

sudo apt-get update
sudo -E apt-get -y install build-essential linux-headers-`uname -r` 
sudo -E apt-get -y install ruby2.3 ruby2.3-dev git zip unzip
sudo -E apt-get -y autoremove


echo "Do we have bosh cli?"
[[ ! -f /usr/local/bin/bosh ]] && ( echo "...no, let's get it" ; export getBoshCli=1)

# BOSH_CLI v2 and CF deployment
if [[ ${boshcli2} -gt 0 ]] ; then
    echo "Looks like we are going with bosh_cli v2"
    wget -nv -O bosh https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-2.0.16-linux-amd64
    chmod 755 bosh
    sudo mv bosh /usr/local/bin

    # Creates single VM based on the manifest. Typically used to create a Director environment. 
    # Operation files and variables can be provided to adjust and fill in manifest before doing a deploy.
    # 'bosh create-env'' command replaces 'bosh-init deploy'' CLI command.
    echo "Creating BOSH deployment..."
    bosh create-env /workspace/bosh-deployment/bosh.yml \
      --state state.json \
      --vars-store ./creds.yml \
      -o /workspace/bosh-deployment/virtualbox/cpi.yml \
      -o /workspace/bosh-deployment/virtualbox/outbound-network.yml \
      -o /workspace/bosh-deployment/bosh-lite.yml \
      -o /workspace/bosh-deployment/jumpbox-user.yml \
      -v director_name=vbox \
      -v internal_ip=192.168.56.6 \
      -v internal_gw=192.168.56.1 \
      -v internal_cidr=192.168.56.0/24 \
      -v network_name=vboxnet0 \
      -v outbound_network_name=NatNetwork

   echo "Done..."

fi

if [[ ${boshcli2} -eq 0 ]] ; then
    echo "Looks like we are going with bosh_cli v1..."
    echo "Let's get 'bosh_cli' and 'bundler' GEM's..."
    sudo -E gem install bosh_cli bundler --no-ri --no-rdoc
    echo "Do we have the necessary Git Repo's?'"
    if [[ ! -d /workspace/bosh-lite-4win/bosh-lite ]] ; then
       echo "ERR: boshlite git repo is missing, exiting..."
       exit 1
    fi
    echo "Yes, adding route..."
    cd /workspace/bosh-lite-4win/bosh-lite 
    ./bin/add-route
    echo "Let's provision CF..."
    echo "...setting the bosh target"
    export BOSH_USER='admin'
    export BOSH_PASSWORD='admin'
    bosh target 192.168.50.4 lite
    echo "...provisioning CF"
    ./bin/provision_cf
fi


echo "BOSH version is: `/usr/local/bin/bosh -v`"

if [[ ! -f /usr/local/bin/spiff && ${boshcli2} -eq 0 ]] ; then
   echo "Looks like we need to get 'spiff' too.."
   wget -nv https://github.com/cloudfoundry-incubator/spiff/releases/download/v1.0.8/spiff_linux_amd64.zip
   unzip spiff_linux_amd64.zip 
   sudo mv spiff /usr/local/bin/
   rm spiff_linux_amd64.zip 
fi

