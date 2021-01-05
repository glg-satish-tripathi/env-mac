FROM ubuntu:20.04

RUN useradd -ms /bin/bash ubuntu

USER ubuntu
WORKDIR /home/ubuntu

CMD ["sleep", "infinity"]
