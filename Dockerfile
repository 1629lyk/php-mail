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

# Enable PHP in Apache
RUN a2enmod php8.1

# Allow Apache to sudo the user creation script without password
RUN rm -f /var/www/html/index.html

COPY index.php /var/www/html/
COPY create_user.php /var/www/html/
COPY adduser_web.sh /usr/local/bin/adduser_web.sh
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /usr/local/bin/adduser_web.sh /entrypoint.sh && \
    echo "www-data ALL=(ALL) NOPASSWD: /usr/local/bin/adduser_web.sh" > /etc/sudoers.d/www-data

# Set default ServerName to suppress warning
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Maildir setup for Postfix
RUN postconf -e "home_mailbox = Maildir/" && \
    postconf -e "inet_interfaces = loopback-only" && \
    postconf -e "mydestination = \$myhostname, localhost"

EXPOSE 80

CMD ["/entrypoint.sh"]

