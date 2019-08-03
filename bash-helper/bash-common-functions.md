# Bash Common Functions

### Content

- Check
  - 1.1 Get Package Manager Name
  - 1.2 Get Host Location
  - 1.3 Check Tools Exist
  - 1.4 Check Service Is Installed
- Operation
  - Backup File Path



### Main

### 1.1 Get Package Manager Name

```shell
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
# call
package_manager=$(get_package_manager)
echo -e "\n\n Package manager is $package_manager ! \n\n"
```

### 1.2 Get Host Location

```shell
# check server location. 
# return: inland or abroad
function get_host_location
{
	local server_location=inland
    ping -c 1 -w 5 google.com 
    if [ $? -eq 0 ]; then 
        server_location=abroad	
	fi
	# return
	echo "$server_location"
}
# call
server_location=$(get_host_location)
echo -e "\n\n Server location is $server_location ! \n\n"
```

### 1.3 Check Tools Exist

```shell
# Check Tools Exist
# return: true or false
function check_tool_exist
{
	local is_exist=false
	if [ -x "$(command -v $1)" ]; then
		is_exist=true
	fi
	echo "$is_exist"
}
# call
tool_name=<tool_name>
is_exist=$(check_tool_exist $tool_name)
if ! [ "$is_exist" = true ]; then
	echo -e "\n\n $tool_name tool is not exist ! \n\n"
fi 
```



### 1.4 Check Service Is Installed

```shell
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
# call
service_name=<service_name>
is_installed=$(check_service_is_installed $service_name)
if ! [ "$is_installed" = true ]; then
	echo -e "\n\n $service_name service is not installed ! \n\n"
fi 
```



### Operations



### 2.1 Get Backup File Path

```shell
# Get Backup File Path
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
# call
backup_filepath /etc/apt/sources.list
```

