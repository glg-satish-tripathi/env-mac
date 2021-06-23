FROM ubuntu:20.04

SHELL ["/bin/bash", "-c"]

# needed for add-apt-repository
RUN apt-get --yes update \
&& apt-get --yes install software-properties-common \
&& rm -rf /var/lib/apt/lists/*

# packages that are required or just helpful for a dev env
# disable warning since it was incorrectly detecting sudo use

# hadolint ignore=DL3004
RUN add-apt-repository --yes ppa:git-core/ppa \
&& apt-get --yes update \
&& apt-get --yes install \
git \
sudo \
curl \
wget \
rsync \
&& rm -rf /var/lib/apt/lists/*

# add ubuntu user, which is pretty standard on most setups
RUN useradd -ms /bin/bash ubuntu
# allow ubuntu to sudo w/o password for everything
RUN echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# we don't want to run as root the rest of the time
USER ubuntu
WORKDIR /home/ubuntu

COPY . /home/ubuntu/env-ubuntu
# hadolint disable=DL3004
RUN cd env-ubuntu \
&& sudo chown -R ubuntu:ubuntu * \
&& git clean -dxff \
&& sudo rm -rf .git \
&& ./bootstrap.bash

# this keeps the container around if used with docker-compose
CMD ["sleep", "infinity"]
