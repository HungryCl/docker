FROM zyclonite/zerotier
RUN apk update && apk add --no-cache bash
RUN apk update && apk add --no-cache sudo 
RUN apk update && apk add --no-cache openssh 
RUN apk update && apk add --no-cache docker 
COPY zt_config.sh zt_config.sh
ENTRYPOINT ["bin/bash", "./zt_config.sh"]