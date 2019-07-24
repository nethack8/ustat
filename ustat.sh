#!/bin/bash
# user info tool. pass a user as an argument.

user=$1

userinfo() {
	id $user &> /dev/null # check if user exists
	if [ "$?" != 0 ]; then
		echo "error: user $user not found"
		exit 1
	fi

	userid=$( id $user 2> /dev/null | egrep -o "uid=[0-9]{1,20}" | tr -d "A-Za-z="; return_one=$? )

	groupid=$( id $user 2> /dev/null | egrep -o "gid=[0-9]{1,20}" | tr -d "A-Za-z=" )
	passwd=$( grep $user /etc/passwd )
	who | grep -q "$1"
	if [ $? == 0 ]; then
		loggedin="true"
	else
		loggedin="false"
	fi
	loginip=$( lastlog -u $user | egrep -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" )
	wdoing=$( w "$user" )

	echo -e "UID: $userid \nGID: $groupid \npasswd: $passwd \nLogged in: $loggedin \nLast login IP: $loginip \nCurrent activity: $wdoing"
}

if [ $# == 0 ] || [ $1 == "-h" ] || [ $1 == "--help" ]; then
	echo "usage: $0 <user>"
	exit 1
fi

userinfo $1
