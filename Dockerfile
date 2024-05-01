FROM ubuntu:20.04
RUN apt-get update
RUN apt-get -y install git wget build-essential wget dos2unix
RUN wget https://cloud.maschath.de/s/dDrZN4DSgJ33E3w/download/Codescape.GNU.Tools.Package.2019.09-03-2.for.MIPS32.MTI.Bare.Metal.Ubuntu-18.04.5.x86_64.tar.gz
RUN tar -xzf Codescape.GNU.Tools.Package.2019.09-03-2.for.MIPS32.MTI.Bare.Metal.Ubuntu-18.04.5.x86_64.tar.gz -C /opt

WORKDIR /app