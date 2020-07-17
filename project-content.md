# Project Content

### Content

- [x] System Settings
  - System Basic Settings
    - sources.list
    - Time zone
  - System Basic Tools Installation
    - sudo
    - system utils
    - make, systemctl, wget, curl, grep, pgrep, pgrep, git
    - vim
    - python
  - System Security Settings
    - ssh
    - firewall
- System Services
  - Shadowsocks
  - V2ray
- Develop Tools
  - Java
    - [x] JDK
    - [x] Maven
  - PHP
- Develop Services
  - Cache
    - [x] Redis
  - Database
    - [ ] MySQL
  - Web Server
    - [ ] Nginx
    - Apache
    - Apache Tomcat
  - DevOps
    - [x] Docker
    - [ ] Jenkins
- Develop Settings
  - [ ] HTTPS
- Others
  - [Bash Helper](bash-helper)



### Main

## System Settings

- [system-initial-settings-and-tools.sh](system-tools/system-initial-settings-and-tools.sh)
- [system-firewall-set-by-ufw.sh](system-settings/system-firewall-set-by-ufw.sh)

### System Basic Settings

**sources.list**

China cloud server should use inland source mirrors.

**Time zone**

To set your area time zone.

Display datetime

```shell
$ date
```



### System Basic Tools Installation

**Debian**

"standard system utilities" by `sudo tasksel --task-package standard `

- apt-listchanges
- lsof
- mlocate
- w3m
- at
- libswitch-perl
- xz-utils
- telnet
- dc
- bsd-mailx
- file
- exim4-config
- m4
- bc
- dnsutils
- exim4
- python2.7
- openssh-client
- aptitude
- bash-completion
- python
- host
- install-info
- bzip2
- reportbug
- krb5-locales
- bind9-host
- time
- info
- liblockfile-bin
- whois
- aptitude-common
- patch
- ncurses-term
- mutt
- mime-support
- exim4-daemon-light
- ftp
- nfs-common
- python-reportbug
- rpcbind
- texinfo
- python-minimal
- procmail
- libclass-isa-perl
- python-apt
- python-support
- exim4-base
- debian-faq
- doc-debian

**CentOS**

`sudo yum -y install yum-utils`: the yum-utils are tools for manipulating repositories and extended package management

`sudo yum -y groupinstall development`: "Development tools yum group" 

- bison
- byacc
- cscope
- ctags
- cvs
- diffstat
- doxygen
- flex
- gcc
- gcc-c++
- gcc-gfortran
- gettext
- git
- indent
- intltool
- libtool
- patch
- patchutils
- rcs
- redhat-rpm-config
- rpm-build
- subversion
- swig
- systemtap

### System Security Settings

**SSH**

**Disable root login and password based login**

- Creating a sudo user on Linux (in root group)

  ```
  # login remote server
  ssh <username>@<server_ip_addr>
  ```

  ```shell
  # create a user. It will initial the user's group, and home directory.
  adduser taogen
  id taogen
  ls -lad /home/taogen/
  
  # set the password fot the user
  passwd taogen
  
  # set sudo permissions for your new admin user
  
  # CHANGE IT
  if "centos"
  usermod -aG wheel <username>
  
  
  # CHANGE IT
  if "debian"
  usermod -aG sudo
  
  # verify sudo permissions
  su - taogen
  whoami
  sudo ls -la /root
  ```

- Install ssh keys on a remote machine (Local computer operations)

  ```shell
  # generating key pair on local
  ssh-keygen -t rsa
  Enter file in which to save the key (/c/Users/Taogen/.ssh/id_rsa): id_rsa_xxx
  # Install the public key in remote server
  ssh-copy-id -i $HOME/.ssh/id_rsa_xxx.pub <username>@<server_ip_addr>
  # Test ssh keybase login (use default private key name) (without user's password)
  ssh <username>@<server_ip_addr>
  # or to specify private key to login
  ssh -i ~/.ssh/<custom_private_key_name> <username>@<server_ip_addr>
  ```

- To Disable root SSH login, edit `/etc/ssh/sshd_config` and password based login (only root user can edit)

  ```
  vi /etc/ssh/sshd_config
  ```

  Set to 

  ```
  ChallengeResponseAuthentication no
  PasswordAuthentication no
  UsePAM no
  PermitRootLogin no
  ```

  Reload ssh configurations

  ```shell
  # CHANGE IT
  if "debian" 
  /etc/init.d/ssh reload
  # or
  sudo systemctl reload ssh
  
  
  # CHANGE IT
  if "centos" 
  /etc/init.d/sshd reload
  # or
  sudo systemctl reload sshd
  ```

- Verification

  - Try to login as root:

    ```
    $ ssh root@<server_ip_addr>
    ```

    Output:

    ```
     Permission denied (publickey,gssapi-keyex,gssapi-with-mic).
    ```

  - Try to login with password only:

    ```
    $ ssh <username>@<server_ip_addr> -o PubkeyAuthentication=no
    ```

    Output:

    ```
     Permission denied (publickey,gssapi-keyex,gssapi-with-mic).
    ```

    

**How to Cancel disable root login and password based login**

Login in by server provider console. To cancel these disable.



**Firewall**

Install ufw on Debian

```shell
sudo apt-get install ufw -y
```

Install ufw on CentOS

```shell
# By default, UFW is not available in CentOS repository. So you will need to install the EPEL repository to your system. 
sudo yum install epel-release -y
# install UFW
sudo yum install --enablerepo="epel" ufw -y
# start UFW service and enable it to start on boot time
sudo ufw enable 
# check the status of UFW
sudo ufw status
```



## System Services



## Develop Tools

#### Java

##### JDK

- [open-jdk-1.8-install-from-repository-linux.sh](develop-tools/open-jdk-1.8-install-from-repository-linux.sh)

- jdk-1.8-install-from-offline-package-linux.sh

##### Maven

- [maven-install-from-repository-linux.sh](develop-tools/maven-install-from-repository-linux.sh)

#### PHP



## Develop Services

#### Cache

##### Redis

- [redis-install-from-repository-linux.sh](develop-services/redis-install-from-repository-linux.sh)
- redis-install-from-online-source-linux.sh

#### Database

##### MySQL

- mysql-install

#### Web Server

##### Nginx

- [nginx-install-from-repository-linux.sh](develop-services/nginx-install-from-repository-linux.sh)

#### DevOps

##### Docker

- [docker-install-from-repository-linux.sh](develop-services/docker-install-from-repository-linux.sh)

- docker-install-from-package-linux

##### Jenkin 



## Develop Settings

- https





##  References

- System Settings
  - [What Debian standard system utilities include](http://csmojo.com/posts/what-debian-standard-system-utilities-include.html)
  - [Installing the CentOS Development Tools (gcc, flex, autoconf, etc)](https://support.eapps.com/index.php?/Knowledgebase/Article/View/438/55/user-guide---installing-the-centos-development-tools-gcc-flex-etc)
  - [yum-utils(1) — Linux manual page]([https://man7.org/linux/man-pages/man1/yum-utils.1.html#:~:text=DESCRIPTION%20top,information%20from%20repositories%20and%20administration.](https://man7.org/linux/man-pages/man1/yum-utils.1.html#:~:text=DESCRIPTION top,information from repositories and administration.))
  - [HOW DO I DISABLE SSH LOGIN FOR THE ROOT USER?](https://mediatemple.net/community/products/dv/204643810/how-do-i-disable-ssh-login-for-the-root-user)
  - [How to disable ssh password login on Linux to increase security](https://www.cyberciti.biz/faq/how-to-disable-ssh-password-login-on-linux/)
  - [How to Install and Use UFW Firewall on Linux](https://linuxconfig.org/how-to-install-and-use-ufw-firewall-on-linux)

--END--