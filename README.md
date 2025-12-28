This repo contains Vagrant configuration and provisioning files for local host development of the MediaWiki web app in a [Vagrant](https://www.vagrantup.com) development environment.

To use these files, you must install vagrant and [virtualbox](https://www.virtualbox.org) first. Once these are installed, you should clone this repository into your develpoment folder. Then, from within this project head,  download and unzip the MediaWiki project into that path. The config files expect the MediaWiki installation to be in the directory "mjfrog" so rename the head of the MediaWiki directory to mjfrog. In the MediaWiki_Vagrant folder, issue the vagrant up command and allow the virtual machine time to configure. Once complete, you will have a virtual machine with an apache2 server listening on port 80 at address 10.10.1.11. To complete the installation of MediaWiki, use your browser to navigate to IP 10.10.1.11 and follow prompts to finish installation of MediaWiki.

A description of the vagrant LAMP stack and link to the original source files can be found here:

https://www.ewaldvanderveken.dev/setting-up-a-lamp-development-environment-in-vagrant/ 
