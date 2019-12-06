# Episode #45 - Learning Ansible with Vagrant (Part 2/4)

                     _           _           _
Welcome to          | |         (_)         | |

This code builds a confluent kafka platform on top of Vagrant using Ansible as configuration management solution. This was primarily used as a basis for setting up multiple machine Vagrant environment.

Code from obtained from [Sysadmincasts Episode #45 - Learning Ansible with Vagrant (Part 2/4)](https://sysadmincasts.com/episodes/45-learning-ansible-with-vagrant-part-2-4)

It covers the following topics

* setup of ssh keys between multiple machines
* setup of Ansible managment node 'mgmt'
* setup of Zookeeper nodes 'zk'
* setup of Kafaka broker nodes 'broker#'
* [Github jeqo/ansible-role-confluent-platform](https://github.com/jeqo/ansible-role-confluent-platform)
* [Ansible Galaxy jeqo.confluent-platform](https://galaxy.ansible.com/jeqo/confluent-platform/)

## File Manifest

* bootstrap-mgmt.sh - Install/Config Ansible & Deploy Code Snippets
* ansible  - Code Snippets
* Vagrantfile - Defines Vagrant Environment
