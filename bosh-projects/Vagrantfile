Vagrant.configure('2') do |config|
  ####################################################################################
  # Setup /etc/hosts on each vm by using vagrant-hostmanager plugin
  ####################################################################################
  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = true
    # set to 'false' if you don't wan't to manage _your_ /etc/hosts
    config.hostmanager.manage_host = true
    config.hostmanager.include_offline = true
  end
  
  config.vm.define "boshlite" do |cf|
    cf.vm.provider :virtualbox do |v, override|
      override.vm.box = 'cloudfoundry/bosh-lite'
      override.vm.box_version = '9000.137.0' # ci:replace
      override.vm.hostname = 'boshlite'
      # override.vm.box_version = '388'
      # To use a different IP address for the bosh-lite director, uncomment this line:
      # override.vm.network :private_network, ip: '192.168.59.4', id: :local
 
      # To use a different IP address for the bosh-lite director, uncomment this line:
      override.vm.network :private_network, ip: '192.168.50.4', id: :local
      override.vm.network :public_network
    end
  end
 
  config.vm.define "boshcli" do |boshlite|
    boshlite.vm.provider :virtualbox do |v, override|
      override.vm.box = 'ubuntu/xenial64'
      override.vm.hostname = 'boshcli'
 
      # To use a different IP address for the bosh-lite director, uncomment this line:
      override.vm.network :private_network, ip: '192.168.50.14', id: :local
      override.vm.network :public_network
      v.memory = 6144
      v.cpus = 2
    end
    # Enable provisioning with a shell script. Additional provisioners such as
    # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
    # documentation for more information about their specific syntax and use.
    boshlite.vm.provision :shell, path: "bootstrap.sh"
    ####################################################################################
    # Detect if we are running on a Windwos host so that we can set 
    # relevent folder sync cfg options  
    ####################################################################################
    # if Vagrant::Util::Platform.windows?
    #     # boshlite.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=777","umask=007"], :owner => "vagrant", :group => "vagrant",  disabled: true
    #     boshlite.vm.synced_folder "../../bosh", "/workspace/", :mount_options => ["dmode=770","fmode=770","umask=007"], :owner => "vagrant", :group => "vagrant", disabled: false
    # else
    #     boshlite.vm.synced_folder ".", "/vagrant", :nfs => { :mount_options => [ 'rw', 'vers=3', 'tcp', 'fsc', 'actimeo=1'] }
    # end
    ######################   <<< OR >>> ###############################################
    # boshlite.vm.synced_folder "../../bosh", "/workspace" , disabled: false
    boshlite.vm.synced_folder ENV['home'] + "/_src/bosh", "/workspace" , disabled: false
    # turn off shared folder
    # boshlite.vm.synced_folder ".", "/vagrant", :disabled => true
    ###################################################################################

  end
end
