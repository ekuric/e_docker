#!/bin/bash 

#  WARNING : use at your own riks, this worked for me,in your case it can broke something 
#  check it before usage 

#  create-delete-containers.sh script can be used to create delete docker containers 
#  tested on Fedora 20
#  action what script will do depends on value of first argument which can be "create" or "delete" 
#  version 0.01, Oct 2014 
#  author Elvir Kuric ( elvirkuric@gmail.com )
#  License GPL2 free to use and do whatever you want with it
#  if used / modified / improved, please give me a credit and send back patch so I can include it
#   in next relese - Thank you!

opts=$(getopt -q -o a:n:i: --longoptions "action:,number:,image:" -n "getopt.sh" -- "$@");

if [ $? -ne 0 ]; then
	printf -- "$*\n"
	printf "\n"
	printf -- "%s\n" "You specified an invalid option"
	printf -- "\tThe following options are available:\n\n"
	printf -- "\t\t-a --action=str - operation : it can be either: create or delete\n"
	printf -- "\t\t-n --number=int - number of containers to create\n"
	printf -- "\t\t-i --image=str - image to use for containers\n" 

	exit 1
fi 

eval set -- "$opts";
echo "processing input parametes" 

while true; do 
	case "$1" in 
		-a|--action)
			shift;
			if [ -n "$1" ]; then
				action="$1"
				shift;
			fi
			;;
		-n|--number)
			shift;
			if [ -n "$1" ]; then 
				number="$1"
				shift;
			fi
			;;
		-i|--image)
			shift;
			if [ -n "$1" ]; then 
				image="$1"
				shift;
			fi
			;;

		--)
			shift;
			break;
			;;

		*)
			echo "something is not working as expected"
			break;;
	esac
done 


# define create_containers and delete_containers functions 

create_containers () {
	for ((m=0; m<$number ;m++));do
		docker run -it -d $image true
		sleep 3
	done
	printf "%s\n" "We created $number containers"
	docker ps -a 
}

delete_containers () {
	for m in $(docker ps -a | awk '{print $1}' | egrep -v CONT);do 
		docker stop $m;docker rm $m
		sleep 2
		printf "%s\n" "removed container $m"
	done 
	printf "%s\n" "All containers removed, output of docker ps -a is now:"
	docker ps -a 
} 

case "$action" in
	create)
		create_containers
	;;
	delete)
		delete_containers
	;;	

	*)
		echo "check input values"
	;;
esac
