#!/usr/bin/env bash
ACTION="$1"
IMAGE="$2"
RANGE="$3"
COUNTER=0
# script to create number of pods


usage() {
    printf "./poolpodcreate <ACTION> [<IMAGE>] [<RANGE>] \n"
    printf "where is:\n"
    printf "<IMAGE> docker image which will be used for pods \n"
    printf "<RANGE> number of pods we want to create \n"
    printf "Example to create pods: ./poolcreate.sh create image_ssh 100\n"
    printf "Example to delete pods: ./poolcreate.sh delete \n"
}



if  [ "$EUID" -ne 0 ]; then
    printf "You have to be root to run script and script takes below parameters\n"
    usage
    exit 0
fi
create_pods() {
    while [ $COUNTER -lt $RANGE ] ;do

cat<<EOF >pod.json
{
  "kind": "Pod",
  "apiVersion": "v1",
  "metadata": {
    "name": "pod-$COUNTER",
    "creationTimestamp": null,
    "labels": {
      "name": "hello-fio"
    }
  },
  "spec": {
    "containers": [
      {
        "name": "pod-$COUNTER",
        "image": "$IMAGE",
	"volumeMounts": [
		{
			"mountPath": "/perf1",
			"name": "perf1"
		}
	],
        "ports": [
          {
            "containerPort": 22,
            "protocol": "TCP"
	  }
        ],
        "resources": {
        },
        "terminationMessagePath": "/dev/termination-log",
        "imagePullPolicy": "IfNotPresent",
        "capabilities": {},
        "securityContext": {
          "capabilities": {},
          "privileged": false,	
	  "command": "/usr/bin/init"
        }
      }
    ],
  "volumes": [
	{
		"name":"perf1",
		"hostPath": {
			"path": "/perf1"
			}
	}
    ],
    "restartPolicy": "Always",
    "dnsPolicy": "ClusterFirst",
    "serviceAccount": ""
  },
  "status": {}
}
EOF
	cat pod.json | oc create -f -
	COUNTER=$[$COUNTER+1] 
done 

}

delete_pods() {
    for pod in $(oc get pods | grep pod- | awk '{ print $1 }') ; do
        oc delete pod $pod --grace-period=0
    done
}

case "$ACTION" in
    c|create)
        create_pods ;;
    d|delete)
        delete_pods ;;
    *)
        printf "Wrong option ... check again\n"; usage ;;
esac
printf "\n"
printf "$RANGE pods were created...\n"
printf " --------------------------- \n"
