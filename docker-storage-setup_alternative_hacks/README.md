## ose-docker-storage guide
Below will be given reasons why ose-docker-storage script

###### Important: read script and use at your responsibility - it helped me to solve my problem, if used against wrong device - it will delete/destroy data on it.

## Why?
Current docker-storage-setup utility [docker-storage-setup](https://github.com/projectatomic/docker-storage-setup) will do all what is necessary in order to configure docker storage setup for docker
It is nice tool and it will not cause damage on system.

In my work, I had requirement to use same device over and over - for tests, and in case there is filesystem signature and/or partition on device passed to docker-storage-setup it will be ignored and result will not be as expected

## Solution
To avoid issue mentioned above, I created ose-docker-storage script which as can be used independently or called before starting `docker-storage-setup` which is again started by docker and which task is to set up storage for docker to use.
By default, `docker-storage-setup` will try to extend root partition (if there are free PEs) and create thin lvm for docker.

If you decide to use separate device for docker storage (what is recommended!), then docker-storage-setup will ignore device if there are fs signatures or partitions

To solve this issue, ose-docker-storage script can be used

## Usage
Important : read script - some steps here can cause troubles in case you made mistake and specify wrong device. You are warned.

First case, you want to use separate device for docker storage

`# ose-docker-storage -s d -d <sdX>`

This will cause device -d to be cleaned of filesystem signatures  and partitions and it will be written in /etc/sysconfig/docker-storage-setup. After this point, once docker-storage-setup script (or docker) is started it will read configuration and do rest

Second case

`# ose-docker-storage  -s v -v <vgname>`

There is volume group already present on system and it has free space and you want to use that free space for docker to carve from it data/metadata docker devices
In this case, `ose-docker-storage` will take that volume group and write it's information to `/etc/sysconfig/docker-storage-setup`. docker-storage-setup script is enough clever to realize to extend volume group and use free space on it for docker

Third case

`ose-docker-storage -s n`
n|none, this says all, ose-docker-storage will not do anything and everything will be left to docker's `docker-storage-setup` script

## More use cases
As docker is *below* openshift, that means docker-storage-setup behaviour described here will be identical for openshift environment. ose-docker-storage can be used also for openshift installations in case you want to be sure that devices planned for docker storage backend are cleaned of partitons / filesystem signatures and ready for docker. Important to note that real workhorse is docker-storage-setup script, ose-docker-storage will just help in border case when devices has partitions/fs signature and you do not want to do this task manually.
It can be used in combination with ansible, and an example of ansible-playbook is attached together with ose-docker-storage.

ansible-playbook usage would be
`# ansible-playbook -i inventry_file ose_setup_docker.yml` --extra-vars='{"device":"sdc}'`
Assuming, `sdc` is device you want to use and want to delete data on it. Adapt device name to your use case
