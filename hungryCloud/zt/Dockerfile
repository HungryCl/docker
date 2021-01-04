FROM zyclonite/zerotier

ENV API_TOKEN NNTH5Py8GnLr2yMHVLhSaKZK6k2LlUHM
ENV NETWORK_ID 12ac4a1e7166f279
RUN apk update && apk add --no-cache bash
RUN apk update && apk add --no-cache sudo 
RUN apk update && apk add --no-cache openssh 
RUN apk update && apk add --no-cache docker
RUN apk update && apk add --no-cache curl
RUN sh -c "curl https://raw.githubusercontent.com/kadwanev/retry/master/retry -o /usr/local/bin/retry && chmod +x /usr/local/bin/retry"

COPY zt_config.sh zt_config.sh
ENTRYPOINT ["bin/bash", "./zt_config.sh"]