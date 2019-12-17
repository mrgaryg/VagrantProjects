#!/bin/bash
# Setup various runtime environment variable and shortcuts

############
#  kubeadm #
if which kubeadm ; then
    # Source kubeadm completion script in your ~/.bashrc file:
    echo 'source <(kubeadm completion bash)' >>~/.bashrc
    # Add the completion script to the /etc/bash_completion.d directory:
    sudo kubeadm completion bash >/etc/bash_completion.d/kubeadm
    # If you have an alias for kubectl, you can extend shell completion to work with that alias:
    echo 'alias ka=ka' >>~/.bashrc
    echo 'complete -F __start_kubeadm ka' >>~/.bashrc
fi

############
#  kubectl #
if which kubectl ; then
    # Source kubectl completion script in your ~/.bashrc file:
    echo 'source <(kubectl completion bash)' >>~/.bashrc
    # Add the completion script to the /etc/bash_completion.d directory:
    sudo kubectl completion bash >/etc/bash_completion.d/kubectl
    # If you have an alias for kubectl, you can extend shell completion to work with that alias:
    echo 'alias k=kubectl' >>~/.bashrc
    echo 'complete -F __start_kubectl k' >>~/.bashrc
fi
