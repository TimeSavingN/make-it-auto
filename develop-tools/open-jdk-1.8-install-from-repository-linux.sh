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


# -------------------------------------
# my functions
# -------------------------------------


# -------------------------------------
# main
# -------------------------------------

# Check package manager
package_manager=$(get_package_manager)
echo -e "\n\n Package manager is $package_manager ! \n\n"

# check is installed
if ! [ -x "$(command -v java)" ]; then
	# yum
	if [ "$package_manager" = "yum" ]; then
		# 1. Search OpenJDK Packages
		# yum search java | grep 'java-'
		
		# 2. install java
		echo -e "\n\n Install JDK 1.8 ... \n\n"
		sudo yum install -y java-1.8.0-openjdk.x86_64
		echo -e "\n\n Install JDK 1.8 is successful ! \n\n"
		
		# 3. Configure Default Java Version
		java -version
		
		# 4. Set JAVA_HOME 
		echo "JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.222.b10-0.el7_6.x86_64/" >> /etc/environment
		source /etc/environment
		echo -e "\n\n Your JAVA_HOME is $JAVA_HOME \n\n"
		echo -e "\n\n install JDK 1.8 is successful ! \n\n"
	fi

	# apt
	if [ "$package_manager" = "apt" ]; then
		# 1. Search OpenJDK Packages
		# apt-cache search openjdk
		
		# 2. install java (OpenJDK)
		echo -e "\n\n Install JDK 1.8 ... \n\n"
		sudo apt-get install -y openjdk-8-jre openjdk-8-jdk
		echo -e "\n\n Install JDK 1.8 is successful ! \n\n"
		
		# 3. Configure Default Java Version
		java -version
		
		# 4. Set JAVA_HOME
		echo "JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/" >> /etc/environment
		source /etc/environment
		echo -e "\n\n Your JAVA_HOME is $JAVA_HOME \n\n"
		echo -e "\n\n install JDK 1.8 is successful ! \n\n"
	fi
else
	echo -e "\n\n You already install java! \n\n"
	java -version
fi


# ENDING
echo -e "\n\n All is done! \n\n"

