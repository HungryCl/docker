FROM nextcloud:latest

RUN apt-get update && apt-get install -y smbclient && rm -rf /var/lib/apt/lists/* 
RUN apt-get update && apt-get -y install sudo
COPY default-ssl.conf /etc/apache2/sites-available/
COPY apache.* /etc/ssl/private/
RUN a2enmod ssl
RUN a2ensite default-ssl.conf
