## fio-pod README 
### Usage
`./fio-pod.sh -f filepod -c config -d testdir`

### Where 

- `filepod` is file name where will be written ip addresses of pods planned to run test inside. It can be any name.
- `config` is string describing test eg `fio_gluster` or `fio_ceph`, or any other description 
- `testdir` is location where fio test will execute its operation. Default is `/var/lib/docker`,but possible to change it. `testdir` location must exist 

### Test description 

Once executed as 

`./fio-pod.sh -f <filename> -c <config_name> -d <test_directory>` 

script will execute fio test inside pods whose ip addresses are collected to `filepod`. system pods such us router and/or docker-registry will 
not be taken into consideration 

This scripts uses `pbench_fio` which is part of [pbench test harness](https://github.com/distributed-system-analysis/pbench) which will install fio 
inside pods if not already done.

`fio-pod` at host side will on all OSE nodes `regiter-tool-set` and pbench data will be collected from host side. From inside pods
we do not collect any data 

### Prerequisite for running 
 
 - It requires fully operational OSE v3 environment. Read [openshift ansible guilde ](https://github.com/openshift/openshift-ansible) how to set it up
 - SSH insde pods has to be enabled. Dockerfile which will build sshd enabled docker image can be found at [sshd enabled docker image ] (https://github.com/openshift/openshift-ansible )
 - pods where test will be run, need to be created in advance. An example of script for bulk pod creatiion can be found here [bulk pod creation] (https://github.com/ekuric/e_docker/tree/master/poolpodcreate)
