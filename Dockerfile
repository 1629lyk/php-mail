FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update && \
    apt install -y \
    apache2 \
    php \
    libapache2-mod-php \
    mailutils \
    postfix \
    sudo \
    whois \
    libsasl2-modules \
    && apt clean

# Allow Apache to sudo the user creation script without password
COPY adduser_web.sh /usr/local/bin/adduser_web.sh
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /usr/local/bin/adduser_web.sh /entrypoint.sh && \
    echo "www-data ALL=(ALL) NOPASSWD: /usr/local/bin/adduser_web.sh" > /etc/sudoers.d/www-data

# Apache & PHP files
RUN rm -f /var/www/html/index.html

COPY index.php /var/www/html/
COPY create_user.php /var/www/html/

# Set default ServerName to suppress warning
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

EXPOSE 80

CMD ["/entrypoint.sh"]

