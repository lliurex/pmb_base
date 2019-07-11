FROM amd64/ubuntu:14.04
RUN echo "deb http://lliurex.net/trusty trusty main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://lliurex.net/trusty trusty-updates main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://lliurex.net/trusty trusty-security main restricted universe multiverse" >> /etc/apt/sources.list
RUN apt update; apt install -y --force-yes mysql-server mysql-client php5-mysql libapache2-mod-php5 php5-gd php5-recode php-fpdf php5-xsl php5-curl php5-yaz yaz
RUN echo "Timeout 1200" > /etc/apache2/conf-available/pmb.conf
RUN echo "extension=yaz.so" > /etc/php5/apache2/conf.d/20-pmb.ini
RUN a2enconf pmb.conf
COPY opac.conf /etc/apache2/sites-available/opac.conf
COPY pmb.conf /etc/apache2/sites-available/pmb.conf
RUN a2ensite pmb.conf opac.conf
RUN sed -i -e "s%^upload_max_filesize.*%upload_max_filesize = 800M%g" /etc/php5/apache2/php.ini
RUN sed -i -e "s%^post_max_size.*%post_max_size = 800M%g" /etc/php5/apache2/php.ini
RUN sed -i -e "s%^max_execution_time.*%max_execution_time = 150%g" /etc/php5/apache2/php.ini
CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]