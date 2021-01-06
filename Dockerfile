FROM ubuntu:20.04

SHELL ["/bin/bash", "-c"]

# needed for add-apt-repository
RUN apt-get --yes update \
&& apt-get --yes install software-properties-common \
&& rm -rf /var/lib/apt/lists/*

# packages that are required or just helpful for a dev env
RUN add-apt-repository --yes ppa:git-core/ppa \
&& apt-get --yes update \
&& apt-get --yes install \
git \
sudo \
curl \
wget \
rsync \
&& rm -rf /var/lib/apt/lists/*

# install node, since some apps down the road will depend on it
RUN set -o pipefail \
&& curl -sL https://deb.nodesource.com/setup_14.x | bash - \
&& apt-get install -y nodejs

# add ubuntu user, whic his pretty standard on most setups
RUN useradd -ms /bin/bash ubuntu
# allow ubuntu to sudo w/o password for everything
RUN echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# we don't want to run as root the rest of the time
USER ubuntu
WORKDIR /home/ubuntu

# install the actual dev environement
RUN git clone 'https://github.com/datfinesoul/env-ubuntu.git' \
'/home/ubuntu/env-ubuntu' \
&& cd env-ubuntu && ./bootstrap.bash

# this keeps the container around if used with docker-compose
CMD ["sleep", "infinity"]
