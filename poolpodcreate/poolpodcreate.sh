#!/usr/bin/env bash

IMAGE="$1"
RANGE="$2"
COUNTER=0
# script to create number of pods

usage() {
    printf "./poolpodcreate <IMAGE> <RANGE> \n"
    printf "where is:\n"
    printf "<IMAGE> docker image which will be used for pods \n"
    printf "<RANGE> number of pods we want to create \n"
}



if [ ["$EUID" -ne 0 ] || [ "$#" -ne 2 ] ; then
    printf "You have to be root to run script and script takes below parameters\n"
    usage
    exit 0
fi
while [ $COUNTER -lt $RANGE ] ;do

cat <<EOF > pod.yml
apiVersion: v1
kind: Pod
metadata:
      name: pod-$COUNTER
spec:
  containers:
  - image: $IMAGE
    name: pod-$COUNTER
    securityContext:
      privileged: False
      command:
      - /usr/bin/init
    imagePullPolicy: IfNotPresent
    volumeMounts:
    - mountPath: "/perf1"
      name: perf1
  volumes:
    - name: perf1
      hostPath:
        path: /perf1
EOF
	printf " ------------------------\n" 
	cat pod.yml | oc create -f -
	COUNTER=$[$COUNTER+1]
done

printf "\n"
printf "$RANGE pods were created...\n"
printf " --------------------------- \n"
