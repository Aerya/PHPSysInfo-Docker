FROM php:8.3-apache

# Paquets utiles pour l'inventaire matériel
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
      git pciutils usbutils lm-sensors \
  && rm -rf /var/lib/apt/lists/*

# Déployer phpSysInfo depuis GitHub (branche main)
WORKDIR /var/www/html
RUN git clone --depth=1 https://github.com/phpsysinfo/phpsysinfo.git ./phpsysinfo \
  && cp phpsysinfo/phpsysinfo.ini.new phpsysinfo/phpsysinfo.ini

# Apache
RUN a2enmod rewrite && \
  printf '%s\n' \
  '<IfModule mod_alias.c>' \
  '  RedirectMatch ^/$ /phpsysinfo/' \
  '</IfModule>' > /etc/apache2/conf-available/psiredirect.conf && a2enconf psiredirect

EXPOSE 80
