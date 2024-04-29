FROM ubuntu:20.04
RUN apt-get update
RUN apt-get -y install git wget build-essential
RUN apt-get install dos2unix
WORKDIR /app