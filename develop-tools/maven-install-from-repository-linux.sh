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


# -------------------------------------
# my functions
# -------------------------------------


function config_maven
{
	echo -e "\n\n Config maven ... \n\n"
	config_file=/etc/maven/settings.xml
	# get location
	server_location='inland'
	ping -c 1 -w 5 google.com
	if [ $? -eq 0 ]; then 
		server_location='abroad'
	fi

	if [ "$server_location" = "inland" ]; then
		if [ -z $(grep "maven.aliyun.com" "$config_file") ]; then
			backup_filepath $config_file
sed -i '/<mirrors>/ a <mirror> \
<id>alimaven</id> \
<name>aliyun maven</name> \
<url>http://maven.aliyun.com/nexus/content/groups/public/</url> \
<mirrorOf>central</mirrorOf> \
</mirror>' $config_file
			echo -e "\n\n Cinfig maven is successful ! \n\n"
		else
			echo -e "\n\n You are already config aliyun mirror ! \n\n"
		fi
	else
		echo -e "\n\n You are in abroad, not need to config aliyun mirror! \n\n"
	fi
	
}

function install_maven
{
	echo -e "\n\n Install maven ... \n\n"

	# 1. install
	sudo $package_manager install -y maven
	
	# 2. verify
	mvn -version
	
	echo -e "\n\n Install maven is successful ! \n\n"
}

# -------------------------------------
# main
# -------------------------------------


# Check package manager
package_manager=$(get_package_manager)
echo -e "\n\n Package manager is $package_manager ! \n\n"

# check is installed
if ! [ -x "$(command -v mvn)" ]; then
	install_maven
else
	echo -e "\n\n You already install maven! \n\n"
	mvn -version
fi

# config aliyun mirror in settings.xml if server is in inland
config_maven
	
# config M2_HOME, MAVEN_HOME
# TODO

# ENDING
echo -e "\n\n All is done! \n\n"
echo -e "\n-----------------------------"
echo -e "Your maven config file is in /etc/maven/settings.xml"
echo -e "-----------------------------\n"

