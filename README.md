This repo contains Vagrant configuration and provisioning files for local host development of the MediaWiki web app in a [Vagrant](https://www.vagrantup.com) development environment.

To use these files, you must install vagrant and [virtualbox](https://www.virtualbox.org) first. Once these are installed, you should clone this repository into your develpoment folder. Then, from within this project head, download and unzip the MediaWiki project into that path. The config files expect the MediaWiki installation to be in the directory "mjfrog" so rename the head of the MediaWiki directory to mjfrog. In the MediaWiki_Vagrant folder, issue the vagrant up command and allow the virtual machine time to configure. Once complete, you will have a virtual machine with an apache2 server listening on port 80 at address 10.10.1.11. To complete the installation of MediaWiki, use your browser to navigate to IP 10.10.1.11 and follow prompts to finish installation of MediaWiki.

A description of the vagrant LAMP stack and link to the original source files can be found here:
https://www.ewaldvanderveken.dev/setting-up-a-lamp-development-environment-in-vagrant/ 

This project is also being used as a local environment for migrating a wiki from older mediawiki versons (e.g. 1.34.x) to release 1.39 and from there to 1.45. WikiMedia advises that older releases must be upgraded sequentially through previous releases before migrating to the latest release. For example, if the Wiki is currently 1.34 and the desire is to migrate to 1.45 but there is a prior release at 1.39, you should first migrate to 1.39 and then from there to 1.45. I plan to use the following process:
<br>
## MediaWiki Upgrade Process
1. Logon to your MediaWiki server and backup your wiki install:
   - mysqldump -h localhost -u <user> -p --default-character-set=utf8 <dbname> > backup.sql
   - tar -czf <mywiki.gz> mywiki
2. git clone this repository to your working directory.
3. Download the latest MediaWiki .gz file to this directory.
4. tar -xzf <mediawikiRelease.gz>
5. Rename the MediaWiki distribution path to the desired wikipedia root folder.
6. Adjust the Vagrant file to install the OS corresponding to the version of MediaWiki and its dependencies (mysql and php) that match the versions of existing Wiki that you wish to migrate.
7. Adjust the following configuration files:
   - provision/config/apache/vhosts/mediawiki.dev.conf
   - provision/components/mysql.sh
8. vagrant up
9. Navigate webbrowser to the vm IP which should bring up the spalsh page for installing MediaWiki.
   - Go through installation process from webbrowser.
10. Restore your wiki archive to a local temp folder (e.g. tar -xzf <mywiki.gz>)
11. Use FileMerge to compare your original wiki install root with the fresh install root.
    - Compare the LocalSettings.php files to determine necessary adjustments.
12. Replace images folder in the new wiki with the old images folder.
13. Reinstall extensions/widgets from
    - https://www.mediawiki.org/wiki/Extension:Widgets
14. Verify that any widgets in your widgets namespace are current (e.g. HTML5mediaAudio - link below requires login credentials):
    - https://www.mediawikiwidgets.org/Audio
15. ssh into the vm (vagrant ssh)
    - Restore your sql database to the newly created wiki database
      - mysql -u <user> -p <dbname> < backup.sql
    - Run maintenance/update.php (php update.php or php run.php update)
16. test wiki with webbrowser.

```
OS Release      PHP Version     MYSQL Version
----------      -----------     -------------
18.04           7.2.24          5.7.42
22.04           8.1.2           8.0.44
```

