This repo contains Vagrant configuration and provisioning files for local host development of the MediaWiki web app in a [Vagrant](https://www.vagrantup.com) development environment.

This project can be used as a migration aid for a MediaWiki instance in an operational environment. For example, with this project, an admin can move the wiki to a local virtual test environment to stage the transition for verification before committing to the migration. The following table shows the target VM to use for the corresponding MediaWiki version.

```
OS Release      PHP Version     MYSQL Version   MediaWiki Target
----------      -----------     -------------   ----------------
18.04           7.2.24          5.7.42          1.34
22.04           8.1.2           8.0.44          1.39
24.04           8.3.6           8.0.44          1.45
```
To use these files, you must install vagrant and [virtualbox](https://www.virtualbox.org) first. Once these are installed, you should clone this repository into your develpoment folder. Then, from within this project head, download and unzip the MediaWiki project (obtained seperately from MediaWiki repo) into that path. The config files expect the MediaWiki installation to be in the directory "mjfrog" so rename the head of the MediaWiki directory to mjfrog. In the MediaWiki_Vagrant folder, issue the vagrant up command and allow the virtual machine time to configure. Once complete, you will have a virtual machine with an apache2 server listening on port 80 at address 10.10.1.11. To complete the installation of MediaWiki, use your browser to navigate to IP 10.10.1.11 and follow prompts to finish installation of MediaWiki.

A description of the vagrant LAMP stack and link to the original source files can be found here:
https://www.ewaldvanderveken.dev/setting-up-a-lamp-development-environment-in-vagrant/ 

This project has been used as an aid for migrating a wiki from older mediawiki versons (e.g. 1.34.x) to release 1.39 and from there to 1.45. MediaWiki advises that older releases must be upgraded sequentially through previous releases before migrating to the latest release. For example, if the Wiki is currently 1.34 and the desire is to migrate to 1.45 but there is a prior release at 1.39, you should first migrate to 1.39 and then from there to 1.45. The process covered is not an "in-place" upgrade of the old installation but a fresh install, restoration of database data, restoration of images, reinstallation of extensions, followed by running the php update scripts. The following steps follow this process:
<br>
## MediaWiki Upgrade Process
1. Logon to your MediaWiki server and backup your wiki database and installation:
   - mysqldump -h localhost -u < user > -p --default-character-set=utf9 < dbname > > backup.sql
   - tar -czf < mywiki.gz > mywiki
2. git clone this repository to your working directory.
3. Download the latest MediaWiki .gz release to this directory and extract:
   - tar -xzf <mediawikiRelease.gz>
4. Rename the MediaWiki distribution path to the desired wikipedia root folder.
5. Adjust the Vagrant file to install the OS corresponding to the version of MediaWiki and its dependencies (mysql and php) that match the versions required to support the Wiki versoin that you are installing.
6. Adjust the following configuration files:
   - provision/config/apache/vhosts/mediawiki.dev.conf
   - provision/components/mysql.sh
7. Bring up the virtual machine:
   - vagrant up
8. Navigate webbrowser to the vm IP which should bring up the spalsh page for installing MediaWiki.
   - Go through installation process from webbrowser.
9. Restore your wiki archive to a local temp folder (e.g. tar -xzf < mywiki.gz >)
10. Use FileMerge (on mac) or similar to compare your original wiki install root with the fresh install root.
    - Compare the LocalSettings.php files to determine necessary adjustments.
11. Replace images folder in the new wiki with the old images folder.
12. Reinstall extensions/widgets from
    - https://www.mediawiki.org/wiki/Extension:Widgets
13. Verify that any widgets in your widgets namespace are current (e.g. HTML5mediaAudio - link below requires login credentials):
    - https://www.mediawikiwidgets.org/Audio
14. ssh into the vm (vagrant ssh) and do following:
    - Restore your sql database to the newly created wiki database
      - mysql -u < user > -p < dbname > < backup.sql</nowiki>
    - Run maintenance/update.php (php update.php or php run.php update or ./run update)
16. test wiki with webbrowser.


## Troubleshooting

- When trying to dump/restore your database, access denied. This is because more recent releases of mysql/mariadb employ a heightened security posture:
```
mysqldump: Error: 'Access denied; you need (at least one of) the PROCESS privilege(s) for this operation' when trying to dump tablespaces
```
A solution is to grant all privileges to your username:
```
mysql> GRANT ALL PRIVILEGES ON *.* TO 'username'@'localhost';
```
A more restrained solution is to just grant only the privilege needed:
```
mysql> GRANT PROCESS ON *.* TO 'username'@'localhost';
```
Make sure to remove excess privileges when restoring your database in your production environment.

- When restoring your widgets in your production environment, you get a php error while running composer:
```
[myserver Widgets]$ ./composer.phar update --no-dev
Loading composer repositories with package information
Updating dependencies ...

In Process.php line 147:

  The Process class relies on proc_open, which is not available on your PHP installation.
```
If you are in a virtual hosting environment with cPanel, on the php root installation page there is typically an "Options" tab where you can change installation settings including "disabled_functions". If "proc_open" is in the "disabled_functions" list, remove it and re-run the command.

- In some environments, you may need to indicate your UTF-8 support in a environment settings in your LocalSettings.php file. To find the UTF-8 support on a Linux system use the following:
```
vagrant@mediawiki:/var/www/mediawiki$ locale
LANG=en_US.UTF-8
LANGUAGE=
LC_CTYPE="en_US.UTF-8"
LC_NUMERIC="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_COLLATE="en_US.UTF-8"
LC_MONETARY="en_US.UTF-8"
LC_MESSAGES="en_US.UTF-8"
LC_PAPER="en_US.UTF-8"
LC_NAME="en_US.UTF-8"
LC_ADDRESS="en_US.UTF-8"
LC_TELEPHONE="en_US.UTF-8"
LC_MEASUREMENT="en_US.UTF-8"
LC_IDENTIFICATION="en_US.UTF-8"
LC_ALL=
```
