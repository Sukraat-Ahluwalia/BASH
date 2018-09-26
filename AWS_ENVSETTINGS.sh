# Script to set AWS environment variables
# The script is divided into three
# functions. find_file() finds the location
# of the credentials file, remove_instances removes
# any instances of AWS keys previously set to ensure
# that .bash_profile has only a fresh set of keys 
# set_keys() sets the new key values.
file_location=""
ENOINST=2

find_file(){
	if find $HOME/.aws -name "credentials" 
	then
		echo "File found in home directory, setting environment variables"
		file_location="$HOME/.aws/credentials"
	elif find /sandbox/.aws -name ".aws/credentials" 
	then	
		echo "File found in sandbox directory, setting environment variables"
		file_location="/sandbox/.aws/credentials"
	else
		echo "File not found in any user directory"
		echo "Login as root to see whether file exists in /root or in /home/vagrant"
	fi
}

remove_instances(){
	echo "Removing any previously set key values"
	if [ ! $(grep -E 'AWS' $1) ]
	then
		echo "No instances found for AWS in $1"
		return $ENOISNT
	else
		sed -i '/AWS/d' $1
	fi
}

set_keys(){
	echo "Reading from file $1"
	keys=($(cat $1 | grep access_key | cut -d"=" -f 2 | tr -d " "))
	token=$(cat $1 | grep session_token | cut -d"=" -f 2 | tr -d " ")
	echo "AWS_ACCESS_KEY - ${keys[0]}"
	echo "AWS_SECRET_ACCESS_KEY - ${keys[1]}"
	echo "export AWS_ACCESS_KEY_ID=${keys[0]}" >> ~/.bash_profile
	echo "export AWS_SECRET_ACCESS_KEY=${keys[1]}" >> ~/.bash_profile
	echo "export AWS_REGION=us-east-2" >> ~/.bash_profile
	echo "export AWS_SESSION_TOKEN=$token" >> ~/.bash_profile
	source ~/.bash_profile
	echo "Environment variables for AWS set, please reboot your sandbox"
	echo "To correctly reboot logout and do a vagrant reload then vagrant ssh"
}


find_file
if [ -n $file_location ]
then
	remove_instances $file_location
	if [ $? -eq 0 ]
	then
		set_keys $file_location
	else
		echo "The pattern was not found so no deletions, setting keys anyway"
		set_keys $file_location
	fi
else
	echo "Oops, something went wrong"
fi
