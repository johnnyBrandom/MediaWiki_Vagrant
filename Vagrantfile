Vagrant.configure("2") do |config|
# For MediaWiki V1.34 use box ubuntu1804
#    config.vm.box = "generic/ubuntu1804"
# For MediaWiki V1.39 use box ubunto2204
#    config.vm.box = "generic-x64/ubuntu2204"
# For MediaWiki V1.45 use box ubuntu-24-04
    config.vm.box = "hashicorp-education/ubuntu-24-04"

    config.vm.provider "virtualbox" do |v|
        v.name = "MediaWiki Project"
        v.memory = 4096
        v.cpus = 1
   end

    # config.vm.synced_folder ".", "/var/www", create: true, nfs: true, mount_options: ["actimeo=2"]
    config.vm.synced_folder ".", "/var/www", owner: "www-data", group: "www-data"

    config.vm.hostname = "mediawiki.dev"
    config.vm.network "private_network", ip: "10.10.1.11"

    config.vm.provision :shell, path: "provision/components/git.sh"
    config.vm.provision :shell, path: "provision/components/apache.sh"
    config.vm.provision :shell, path: "provision/components/php.sh"
    config.vm.provision :shell, path: "provision/components/mysql.sh"
    config.vm.provision :shell, path: "provision/components/phpmyadmin.sh"
    config.vm.provision :shell, path: "provision/components/yarn.sh"
    config.vm.provision :shell, path: "provision/components/composer.sh"

    config.vm.provision :shell, inline: "echo 'cd /var/www' >> /home/vagrant/.profile"
end
