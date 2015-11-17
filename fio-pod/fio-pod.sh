#!/usr/bin/env bash

# fio bench test for openshift pods
# requires pbench_fio from https://github.com/distributed-system-analysis/pbench
# to be installed on OSE master and OSE nodes

# variables

fiobin="/opt/pbench-agent/bench-scripts/pbench_fio"
podfile="podfile"
config="fio_testing"
testtypes="read,write,rw,randread,randwrite,randrw"
otheropt=""

usage() {
    printf -- "./fio-pod.sh -f filepod -c config -t testtype -o "other pbench_fio options" \n"
    printf -- "where is:\n"
    printf -- "podfile - list of pod's ip addresses where test will be run\n"
    printf -- "config - string describing fio test config , eg fio-ceph-run1, fio-rhs-run1...etc\n"
    printf -- "testtype - fio test type to run, list comma separated test, eg: read,write, randread \n"
    printf -- "otheropt - run pbench_fio -h for list, quoted list of desired pbench_fio options - they will be passed to pbench_fio\n"
    exit 0
}

if [ "$EUID" -ne 0 ]; then
    printf "You have to be root to run script, we exited - check parameters\n"
    usage
    exit 0
fi

opts=$(getopt -q -o f:c:t:o:h --longoptions "filepod:,fconfig:,testtypes:,otheropt:,help" -n "getopt.sh" -- "$@");
eval set -- "$opts";
echo "processing options"
while true; do
    case "$1" in
        -f|--filepod)
            shift;
            if [ -n "$1" ]; then
                filepod="$1"
		        shift;
            fi
        ;;
        -c|--fconfig)
            shift;
            if [ -n "$1" ] ; then
                fconfig="$1"
                shift;
            fi
        ;;
        -t|--testtypes)
            shift;
            if [ -n "$1" ]; then
                testtypes="$1"
                shift;
            fi
        ;;

        -o|--otheropt)
            shift;
            if [ -n "$1" ]; then
                otheropt="$1"
                shift;
            fi
        ;;

        -h|--help)
            shift;
            usage
        ;;
        --)
            shift;
            break;
        ;;
        *)
            shift;
            break;
        ;;
    esac
done

# write pod file based on pods ip addresses - this will be run on OSE master
write_podfile() {
    # just taking into considerations pods created by this script
    rm $podfile.txt
    for pod in $(oc get pods | awk '{print $1}'| egrep -v 'NAME|docker-registry|router');do
        oc describe pod $pod | grep IP | awk '{print $2}'>> $podfile.txt
    done
}

# tool-set-register for OSE nodes. If necessary to register-tool-set against other machines which are not
# OSE nodes ( not in oc get nodes output ), then do it manually

tool-set-register() {
    for node in $(oc get nodes | awk '{print $1}'  | grep -v NAME); do
        # requires SSH passwordless login -- configure this in advance
        ssh -o StrictHostKeyChecking=no -nTx root@$node yum -y install pbench-*; source /opt/pbench-agent/profile; source /opt/pbench-agent/base
        register-tool-set --remote=$node
        printf "Tools registered for node : $node\n"
    done
}

# main
run_test() {
        $fiobin --test-types="$testtypes"  --config=$fconfig --clients=$(cat $podfile.txt | awk -vORS=, '{ print $1 }' | sed 's/,$/\n/') $otheropt
}

write_podfile
tool-set-register
run_test

# sleep 5 mins - this can be omitted, but just leaving time for data collection
sleep 300

move-results --prefix="$config"
printf "Test finished.... results moved\n"