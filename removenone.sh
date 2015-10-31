#!/bin/bash

# WARNING : use at your own riks, this worked for me,in your case it can broke something 
# check it before usage 

#  script to remove orphaned docker containers 
#  "orphaned" means IMAGE has at REPOSITORY and TAG field in "docker images" outpout <none>

# removenone.sh 
# version 0.01, Oct 2014 
# author Elvir Kuric ( elvirkuric@gmail.com )
# License GPL2 free to use and do whatever you want with it

# if used / modified / improved, please give me a credit and send back patch so I can include it
# in next relese - Thank you!

usage () {
	printf "%s\n" "Script to remove docker images which has <none> in repository and TAG field"
	printf "%s\n" "Script usage is: $0"
}

check_root () {

	if [ "$EUID" -ne 0 ];then
		printf "%s\n" "You have to be root in order to use this script"
		exit 1 
	fi 
}
remove_image () {

	for m in $(docker images | awk '{if ($1 ~ /\<none>/ ) print $3}');do
		for n in $(docker history --no-trunc $m | awk '{print $1}' | egrep -v IMAGE);do 
			cd /var/lib/docker/graph
			printf "%s\n" "Removing $n ... "
			rm -rf $n
			printf "%s\n" "Removed $n from /var/lib/docker/graph";sleep 5
		done 	
	done
	
}

usage 
check_root
remove_image

printf "%s\n" "Output of docker images is showed below ... job done"
docker images 
