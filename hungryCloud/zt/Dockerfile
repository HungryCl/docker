FROM bltavares/zerotier

RUN apt-get update && apt-get -y install bash
RUN apt-get update && apt-get -y install sudo 
RUN apt-get update && apt-get -y install openssh-server openssh-client 
RUN apt-get update && apt-get -y install curl

RUN sudo curl -sSL https://get.docker.com/ | sh
RUN sh -c "curl https://raw.githubusercontent.com/kadwanev/retry/master/retry -o /usr/local/bin/retry && chmod +x /usr/local/bin/retry"

COPY zt_config.sh zt_config.sh
ENTRYPOINT ["bin/bash", "./zt_config.sh"]

