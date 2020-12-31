FROM zyclonite/zerotier
RUN apk update && apk add --no-cache bash
RUN apk update && apk add --no-cache sudo 
COPY zt_config.sh zt_config.sh
ENTRYPOINT ["bin/bash", "./zt_config.sh"]