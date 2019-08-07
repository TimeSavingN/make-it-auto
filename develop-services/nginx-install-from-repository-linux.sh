#!/bin/bash

# -------------------------------------
# common functions
# -------------------------------------

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

# apt update
# import get_package_manager()
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


# -------------------------------------
# my functions
# -------------------------------------

function install_nginx
{
	if [ "$package_manager" = apt ]; then
		sudo apt-get install -y nginx
	fi
	
	if [ "$package_manager" = yum ]; then
		sudo yum install -y epel-release
		sudo yum install -y nginx
	fi
	
	sudo systemctl enable nginx
	sudo systemctl restart nginx
	sudo systemctl status nginx
}

# -------------------------------------
# main
# -------------------------------------

# Prepare

package_manager=$(get_package_manager)
echo -e "\n\n Package manager is $package_manager ! \n\n"

apt_update

# Install

install_nginx


# ENDING
echo -e "\n\n All is done! \n\n"
echo -e "--------------------------------------------------------"
echo -e "View nginx status: sudo systemctl status nginx"
echo -e "Start nginx: sudo systemctl start nginx"
echo -e "nginx configuration file: /etc/nginx/conf.d "
echo -e "Verify nginx: http://server_domain_name_or_IP/ "
echo -e "--------------------------------------------------------"