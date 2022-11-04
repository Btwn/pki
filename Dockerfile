FROM debian
RUN apt-get update && apt-get install wget curl -y
RUN wget https://github.com/smallstep/cli/releases/download/v0.14.6/step-cli_0.14.6_amd64.deb
RUN dpkg -i step-cli_0.14.6_amd64.deb
WORKDIR /home/step
ENTRYPOINT ["step"]