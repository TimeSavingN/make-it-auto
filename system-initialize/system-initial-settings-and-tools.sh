#!/bin/bash


# -------------------------------------
# common functions
# -------------------------------------
function add_env_variable
{
	echo "Add environment variable - key: $1, value: $2"
	cp /etc/profile /etc/profile.bak.$(date '+%Y-%m-%d_%H-%M-%S')
  echo "export $1=$2" >> /etc/profile
  cat /etc/profile
  source /etc/profile
}

# Backup File Path
function backup_filepath
{
	bak_path="$1.bak"  #/etc/apt/sources.list.bak
    i=1
    while true; do
        if ! [ -f $bak_path ]; then
            break
        fi
        bak_path="${bak_path}.$i"
        i=$[$i + 1]
    done
    sudo cp $1 $bak_path
}

# apt update
function apt_update
{
	echo -e "\n\n apt update... \n\n"
    if [ "$package_manager" = "yum" ]; then
        sudo yum update -y && yum upgrade && yum autoremove
    fi
    if [ "$package_manager" = "apt" ]; then
        sudo apt update && apt upgrade -y && apt autoremove && apt autoclean
    fi
    echo -e "\n\n apt update is finished ! \n\n"
}

# Set sources.list
# import backup_filepath
function set_sources_list
{
    server_location='inland'
    ping -c 1 -w 5 google.com
    if [ $? -eq 0 ]; then
        server_location='abroad'
    fi
    echo -e "\n\n Server location is $server_location ! \n\n"
    source_path=/etc/apt/sources.list
	if [ "$server_location" = "inland" ]; then
		if [ -f $source_path ]; then
			if ! [[ -n $(sudo grep "http://mirrors.aliyun.com/ubuntu/" $source_path) ]]; then
				backup_filepath $source_path
echo "
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
"| sudo tee /etc/apt/sources.list  # add -a for append (>>) ;
				echo -e "\n\n sources.list update to aliyun. \n\n"
			else
				echo -e "\n\n Already is aliyun sources ! \n\n"
			fi
		else
			echo -e "\n\n Not found /etc/apt/sources.list ! \n\n"
		fi
    else
        echo -e "\n\n server is in abroad, not need change to aliyun sources! \n\n"
    fi
}

# set time zone
function set_time_zone
{
    if [ -z "$(timedatectl | grep +08)" ]; then
        timedatectl set-timezone Asia/Shanghai
        echo -e "\n\n Set timezone to +08 is successful ! \n Now the datetime is $(date). \n\n"
    else
        echo -e "\n\n Timezone is already +08 ! \n\n"
    fi
}

# check package manager
# return: apt or yum
function get_package_manager
{
	local package_manager=apt
    if [ -x "$(command -v yum)" ]; then
        package_manager=yum
    fi
	# return
	echo "$package_manager"
}

# Config vim
function config_vim
{
    vim_config_path=~/.vimrc
    if [ -x "$(command -v vim)" ]; then
        if ! [ -f $vim_config_path ]; then
            touch $vim_config_path
        fi
        if [ -n "$(grep "set number" $vim_config_path)" ]; then
            echo -e "\n\n Vim is already config ! \n\n"
        else
            echo "
:set number

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set autoindent
set cindent

set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
"| sudo tee $vim_config_path
            echo -e "\n\n Set vim config successfully ! \n\n"
        fi
    else
        echo -e "\n\n Vim is not installed ! \n\n";
    fi
}

# -------------------------------------
# my functions
# -------------------------------------




# -------------------------------------
# main
# -------------------------------------

# 0. prepare

package_manager=$(get_package_manager)

# 0. install sudo
if ! [ -x "$(command -v sudo)" ]; then
    echo -e "\n\n install sudo ... \n\n"
    $package_manager install sudo -y
    echo -e "\n\n install sudo is successful ! \n\n"
fi


# 1. System Settings

# 1.1 Set sources.list
set_sources_list

# 1.2 Set Timezone to +08 (Asia/Shanghai)
set_time_zone

# 1.3 Set less using utf-8 character encoding
add_env_variable "LESSCHARSET" "utf-8"

# 2.  System Tools

# 2.1 apt update
apt_update

# 2.2 system utils
echo -e "\n\n system utils installation ... \n\n"
if [ "$package_manager" = "yum" ]; then
	sudo yum -y install yum-utils
	sudo yum -y groupinstall development
else
	sudo tasksel --task-package standard
fi
echo -e "\n\n system utils installation finished ! \n\n"

# install make
if ! [ -x "$(command -v make)" ]; then
    echo -e "\n\n Install make... \n\n"
    sudo $package_manager install build-essential -y
    echo -e "\n\n Install make is successful! \n\n"
fi

# install python3
if ! [ -x "$(command -v python)" ]; then
	echo -e "\n\n Install python... \n\n"
	if [ "$package_manager" = "yum" ]; then
		# IUS Community repositories
		sudo yum -y install https://centos7.iuscommunity.org/ius-release.rpm
		sudo yum -y install python36u python36u-pip
		sudo yum -y python36u-devel
	else
		# Installing Python 3.6.4 from the Debian testing repository
		debian_test_repo="deb http://ftp.de.debian.org/debian testing main"
		if ! [[ -n $(cat /etc/apt/sources.list | grep "$debian_test_repo") ]]; then
			sudo echo "$debian_test_repo" >> /etc/apt/sources.list
		fi
		sudo apt-get update
		sudo apt-get install python3.6 -y
	fi
	python --version
	echo -e "\n\n Install python 3.6 is successful ! \n\n"
fi

# install packages
declare -a arr=("wget" "curl" "grep" "pgrep" "lsof" "git" "vim")

for i in "${arr[@]}"; do
	if ! [ -x "$(command -v $i)" ]; then
		echo -e "\n\n Install $i ... \n\n"
		sudo $package_manager install $i -y
		echo -e "\n\n Install $i is successful! \n\n"
	else
		echo -e "\n\n $i is already installed ! \n\n"
	fi
done

# config

config_vim



# ENDING
echo -e "\n\n All is done! \n\n"
