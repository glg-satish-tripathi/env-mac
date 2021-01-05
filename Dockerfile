FROM ubuntu:20.04

# needed for add-apt-repository
RUN apt-get --yes update
RUN apt-get --yes install software-properties-common

RUN add-apt-repository --yes ppa:git-core/ppa
RUN apt-get --yes update
RUN apt-get --yes install \
  git \
  sudo \
  curl \
  vim \
  rsync

# we don't want to run as root the rest of the time
RUN useradd -ms /bin/bash ubuntu
RUN echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
RUN apt-get install -y nodejs

USER ubuntu
WORKDIR /home/ubuntu

RUN git clone 'https://github.com/datfinesoul/env-ubuntu.git' \
  '/home/ubuntu/env-ubuntu'
RUN cd env-ubuntu && ./bootstrap.bash

CMD ["sleep", "infinity"]
