#!/bin/bash
# kubeadm installation instructions as on
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/


function joinCluster()
{
    echo "Attempting to autojoin the cluster"
    if [ -f /vagrant/.kube/conf ] ; then
        echo "Unable to find the discovery file..."
        kubeadm join --discovery-file /vagrant/conf
    elif [ -f /vagrant/join.token ]; then
        # TODO: an alternate and a slightly better way is to use the following
        # - Token-based discovery without CA pinning
        #   https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-join/#token-based-discovery-without-ca-pinning
        #   This would probably require
        #    1. 'kubeadm token  create > /vagrant/join.token'
        #    2. 'kubeadm join --token=$(cat /vagrant/join.token) --discovery-token-unsafe-skip-ca-verification master:6443'
        echo "Attempting token-based discovery"
        kubeadm join --token=$(cat /vagrant/join.token) --discovery-token-unsafe-skip-ca-verification master:6443
    else
        echo "Unable to find the discovery-file or token-file to autojoin"
        echo "Please run through appropriate steps to generate the token and join the cluster maunally"
    fi
}

scriptname=$(basename $0)
echo "####################################################################"
echo "${scriptname}: Let's setup kubernetes..."
echo "####################################################################"

echo "Adding k8s yum repo..."
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

echo "Set SELinux in permissive mode (effectively disabling it)"
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

echo "Disable swap (assuming that the name is /dev/centos/swap"
sed -i 's/^\/dev\/mapper\/centos-swap/#\/dev\/mapper\/centos-swap/' /etc/fstab

echo "Install k8s packages"
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

echo "Tune kernel parameters"
systemctl enable --now kubelet

echo "Set iptables bridging"
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system


echo "=============================="
echo "** System config is all set **"
echo "=============================="
echo "** Pulling k8s images **"
# kubeadm config images pull

if [[ $HOSTNAME = "master" ]] ; then

    echo "*** Initializing kubernetes cluster ***"
    # TODO: Need to find a way to inject master's ip address programitically
    #    look into using something similar to the following
    #        config.vm.provision "shell", path: "provisionscript.sh", env: {"MYVAR" => "value"}
    #    where MYVAR would be the value looked up from Vagrantfile [node:ip] array
    #    https://github.com/hashicorp/vagrant/issues/7015
    #    https://gist.github.com/bivas/6192d6e422f8ff87c29d
    #    https://www.vagrantup.com/docs/provisioning/shell.html#env
    kubeadm init --pod-network-cidr 192.168.4.0/24  \
      --apiserver-advertise-address=192.168.4.10
    echo "Generate a join script"
    kubeadm token create --print-join-command > /vagrant/join.sh
    [ -f /vagrant/join ] && chmod +x /vagrant/join.sh
    echo "Generating a token file for workers to join"
    kubeadm token  create > /vagrant/join.token
    echo "Setting up Weave CNI"
    mkdir $HOME/.kube
    cp /etc/kubernetes/admin.conf $HOME/.kube/config
    kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
    echo "*** Copy k8s configs to /home/vagrant/.kube"
    mkdir -p /home/vagrant/.kube
    cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
    # cp -i /etc/kubernetes/admin.conf /vagrant/.kube/config
    chown vagrant:vagrant /home/vagrant/.kube/config
fi

if echo $HOSTNAME | grep worker
then
    set -xv
    joinCluster
#   wrkrToken=$(kubeadm token create)
fi


echo "${scriptname}: DONE!!!"