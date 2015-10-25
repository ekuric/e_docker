# From fedora image
FROM fedora

MAINTAINER Elvir Kuric <elvirkuric@gmail.com>


# install pacemaker packages necessary to build pacemeaker cluster 
RUN yum clean all ; yum install -y python-matplotlib numpy python-pandas


# Setup basic environment stuff
ENV container docker
ENV HOME /root
ENV USER root
ENV LANG en_US.UTF-8
WORKDIR /root

# Setup root password in the container
RUN echo "root:centos" | chpasswd

# Launch bash as the default command if none specified.
CMD ["/bin/bash"]
