#!/bin/bash
# Ini adalah script bash sederhana untuk menginstall Nginx, PHP 7 dan MySQL pada CentOS 6 via YUM.
# Hanya untuk proses pembelajaran peserta saja.

# cek apakah OS yang digunakan
if cat /etc/centos-release |
  grep -qFe "CentOS release 6."
then
  echo "Update OS..."
  yum update -y
  echo "Install EPEL Repo..."
  yum install epel-release -y
  echo 'Install wget...'
  yum install wget -y
  echo 'Download remi RPM...'
  wget http://rpms.remirepo.net/enterprise/remi-release-6.rpm
  echo 'Install remi RPM...'
  rpm -Uvh remi-release-6.rpm

  echo 'Install MySQL...'
  yum install mysql mysql-server -y
  echo 'Start MySQL Service...'
  service mysqld start
  echo 'Auto start MySQL service saat OS selesai booting...'
  chkconfig mysqld on

  echo 'Install Nginx...'
  yum install nginx -y
  echo 'Auto start Nginx service saat OS selesai booting...'
  chkconfig nginx on
  echo 'Start Nginx Service...'
  service nginx start

  echo 'Install PHP...'
  yum install php73 php73-php-fpm -y
  echo 'Auto start PHP-FPM service saat OS selesai booting...'
  chkconfig php73-php-fpm on
  echo 'Start PHP-FPM Service...'
  service php73-php-fpm start

else
  echo "Bukan CentOS 6"
fi
