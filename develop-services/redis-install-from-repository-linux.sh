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

# Check Service Is Installed
# return: true or false
function check_service_is_installed
{
	local is_installed=false
	if [ -n "$(systemctl | grep $1)" ]; then
		is_installed=true
	fi
	echo "$is_installed"
}

# -------------------------------------
# my functions
# -------------------------------------


# -------------------------------------
# main
# -------------------------------------

# prepare
package_manager=$(get_package_manager)
echo -e "\n\n Package manager is $package_manager ! \n\n"
sudo $package_manager update

# install
service_name=redis-server
if ! [ "$(check_service_is_installed $service_name)" = true ]; then
	echo -e "\n\n Install redis ... \n\n"
	sudo $package_manager install -y redis-server
	sudo sed -i 's/^supervised no$/supervised systemd/' /etc/redis/redis.conf
	sudo systemctl restart redis
	echo -e "\n\n Install redis is successful ! \n\n"
else
	echo -e "\n\n $service_name service is installed ! \n\n"
fi

sudo systemctl status redis

# ENDING
echo -e "\n\n All is done! \n\n"
echo -e "--------------------------------------------------------"
echo -e "View redis status: sudo systemctl status redis"
echo -e "Start redis service: sudo systemctl start redis"
echo -e "Redis configuration file: /etc/redis/redis.conf"
echo -e "--------------------------------------------------------"