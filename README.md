# Instalasi CentOS 6, MySQL, Nginx, PHP 7, Wordpress PKL SMK 2 Kaliada Lampung
[![license](https://img.shields.io/github/license/ditatompel/PKL-SMK-2-KALIADA-WDS.svg)](LICENSE)

Repositori ini dibuat sebagai kisi-kisi & sedikit tutorial instalasi CentOS 6, Nginx, PHP 7 dan menjalankan CMS Wordpress pada VPS  untuk `peserta PKL SMK 2 Kaliada Lampung` di WDS pada khususnya dan untuk mereka yang ingin memulai belajar tentang Linux, dan Webserver pada umumnya.

Contoh Video :
* https://www.youtube.com/watch?v=hG9oVbAL-BE (Install CentOS, PHP, Nginx, MySQL)   
* https://www.youtube.com/watch?v=umFxK0--HRg (install Wordpress)

> Note : tidak semua yang ada pada video sesuai dengan kisi-kisi di bawah ini. Dengan memahami perbedaan dari video dan step-step pada halaman ini, diharapkan peserta PKL dapat aktif bertanya jika ada yang perlu ditanyakan.

## Tujuan Pembelajaran
1. Mengerti Perdaan dedicated server dan VPS server, VM dan LXC serta arti virtualisasi.
2. Pengoprasian dasar software virtualisasi (Proxmox)
3. Installasi CentOS (6)
4. Mengerti dasar-dasar perintah pada sistem operasi Linux.
5. Mengerti dasar file permission pada Unix-like OS.
6. Mengenal dan mengerti berbagai distro dan keluarga Linux.
7. Mampu melakukan instalasi aplikasi melalui package manager yang disediakan oleh distro yang digunakan.
8. Mengerti alur dan cara kerja firewall (iptables) dan mengetahui standard port yang digunakan masing-masing software / aplikasi.
9. Membuat dan mengkonfigurasi web server dan database server untuk digunakan oleh CMS (dalam hal ini WordPress)
10. Peserta berani melakukan trial & error, memanfaatkan search engine sebagai referensi, dan mengetahui kesalahan dan langkah yang harus dilakukan dari error yang ada.


## Materi
Dalam materi ini, hardware dan beberapa software yang digunakan adalah :
* Server : Server dengan CPU yang mendukung virtualisasi.
* Virtualisasi : Proxmox VE 5.3
* VPS OS : CentOS 6.10
* Database Server : MySQL / MariaDB
* Webserver : Nginx
* CMS : WordPress
* Programming Language Software : PHP 7.3
* Modern browser untuk mengakses dan mengoprasikan Proxmox melalui web interface.
* Network Connection (Dalam hal ini menggunakan IP lokal untuk VM Guest)

Adapun beberapa software tambahan untuk membantu mempermudah pengoprasian :
* Putty (Remote SSH)
* PhpMyAdmin
* 1 atau 2 gelas kopi

### Konfigurasi VPS
Video tutorial konfigurasi VPS (Membuat Guest VM) pada Proxmox dapat dilihat di [https://www.youtube.com/watch?v=hG9oVbAL-BE](https://www.youtube.com/watch?v=hG9oVbAL-BE) menit 0 hingga menit 1:20.

Pada video tersebut sebagian besar adalah konfigurasi default untuk pembuatan VM Guest.   

[Dokumentasi Proxmox] [proxmox documentation]

### Installasi OS VPS (CentOS)
VM Guest OS yang digunakan adalah CentOS versi 6.10. Video tutorial instalasi CentOS minimal dapat dilihat di [https://youtu.be/hG9oVbAL-BE?t=80](https://youtu.be/hG9oVbAL-BE?t=80) mulai menit 1:20 hingga menit 5:15.

Mengenai IP, dalam hal ini peserta PKL dapat menggunakan konfigurasi IP berikut untuk Guest VM :   

Network 192.168.100.0/24   
gateway 172.16.8.1   

Manfaatkan dan gunakan dengan bijak alokasi IP dan resource server yang ada.

### Installasi software
Video [https://youtu.be/hG9oVbAL-BE?t=402](https://youtu.be/hG9oVbAL-BE?t=402) mulai menit 6:42

#### Install Repositori Yang Dibutuhkan
Video [https://youtu.be/hG9oVbAL-BE?t=402](https://youtu.be/hG9oVbAL-BE?t=402) mulai menit 6:42 hingga menit 10:30

3 Software utama yang kita butuhkan adalah Nginx, MySQL dan PHP versi 7.x.   

Untuk MySQL, repositori dari CentOS sudah tersedia.

Sedangkan untuk Nginx kita perlu menambahkan repositori tambahan yaitu [EPEL].

Kemudian, repositori CentOS juga sebenarnya sudah ada PHP, namun dengan versi 5.3 dimana sudah tidak reliabel lagi. Maka dari itu kita dapat menggunakan repositori [REMI] yang menyediakan PHP versi 7.

Install EPEL  :
```bash
yum install epel-release
```
Info lebih lengkap : [https://www.liquidweb.com/kb/enable-epel-repository/](https://www.liquidweb.com/kb/enable-epel-repository/)

install REMI
```bash
wget http://rpms.remirepo.net/enterprise/remi-release-6.rpm
rpm -Uvh remi-release-6.rpm
```
Situs : [https://rpms.remirepo.net/](https://rpms.remirepo.net/)

Dari 3 command diatas, maka, repo EPEL dan REMI sudah ada pada OS.


#### Install MySQL
Video [https://youtu.be/hG9oVbAL-BE?t=639](https://youtu.be/hG9oVbAL-BE?t=639) mulai menit 10:39 hingga menit 14:01

Install MySQL server menggunakan `yum install`
```bash
yum install mysql mysql-server -y
```
Jalankan MySQL server dengan menggunakan perintah :
```bash
service mysqld start
```

Secara default, setelah fresh install MySQL, user root pada aplikasi MySQL masih kosong (login tanpa password), maka setelah proses instalasi MySQL dan service MySQL sudah berjalan, jalankan `mysql_secure_installation` dan ikuti petunjuk untuk merubah password.

Setelah memberikan password pada user `root MySQL`, perintahkan OS agar MySQL server berjalan secara otomatis setelah OS restart / booting dengan perintah :

```bash
chkconfig mysqld on
```

#### Installasi Nginx
Video [https://youtu.be/hG9oVbAL-BE?t=840](https://youtu.be/hG9oVbAL-BE?t=840) mulai menit 14:00 hingga menit 15:53
Install Nginx melalui yum install, jalankan auto start saat booting dan start service nginx dengan periintah :

```bash
yum install nginx
chkconfig nginx on
service nginx start
```

#### Reconfigure iptables Firewall
Video [https://youtu.be/hG9oVbAL-BE?t=953](https://youtu.be/hG9oVbAL-BE?t=953) mulai menit 15:53 hingga menit 17:37.

Secara defaut firewall pada CentOS hanya membuka port 22 (SSH).
Konfigurasi lagi iptables supaya firewall membuka port 80 untuk http server.

Untuk lebih aman, `export` firewall rule dengan perntah `iptables-save` > output filenya

```bash
mkdir ~/config
iptables-save > ~/config/iptables.conf
```

Berikut ini contoh rules default iptables CentOS (output dari `iptables-save`)
```
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [63650:3952086]
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
```

Buka dan edit file iptables.conf yang telah terbuat dan tambahkan rules berikut untuk membuka protokol TCP port 80.
```bash
-A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
```
INGAT bahwa sistem iptables firewall adalah chain, artinya tiap rules berhubungan 1 sama lain. Jika rules untuk membuka port 80 diatas ada dibawah rules jump REJECT : `-A INPUT -j REJECT --reject-with icmp-host-prohibited`, maka rules untuk membuka port 80 tersebut tidak ada gunanya karena sudah direject terlebih dahulu.
Sehingga, letakkan rules membuka port `SELALU DIATAS` `INPUT -j REJECT`!

Kurang lebihnya seperti berikut konfigurasinya :
```
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [61:7388]
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
```

restore konfigurasi yang telah kita edit dengan perintah `iptables-restore` < input file
```bash
iptables-restore < ~/config/iptables.conf
```
Simpan rules dengan perintah
```bash
service iptables save
```
dan restart iptables untuk memastikan rules baru sudah berjalan.

```bash
service iptables restart
```

Atu jika tidak suka mengedit configurasi yang sudah
Note :
```bash
iptables -I INPUT 5 -p tcp -m tcp --dport 80 -j ACCEPT
```
Perintah diatas artinya   
`-I` = Insert / menyelipkan   
`INPUT 5` = pada chain INPUT di posisi baris ke 5   
`-p tcp -m tcp ` = protokol TCP   
`--dport 80` = destination port / port tujuan 80   
`-j ACCEPT` = lompat ke aksi ACCEPT / terima

jangan lupa save rules yang sudah kita buat
```bash
service iptables save
service iptables restart
```

Cek webserver melalui browser. Pastikan dapat diakses.

#### Installasi PHP
Video [https://youtu.be/hG9oVbAL-BE?t=1056](https://youtu.be/hG9oVbAL-BE?t=1056) mulai menit 17:37 hingga menit 21:59
Kita akan menggunakan php 7.3, install menggunakan perintah yum, jalankan auto start saat booting dan start service php-fpm dengan perintah  :
```bash
yum install php73
yum install php73-php-fpm
chkconfig php73-php-fpm on
service php73-php-fpm start
```
Note : Nginx perlu sebuah "media" untuk memproses PHP, yaitu dengan php-fpm yang nantinya dia akan listen ke ip:port 127.0.0.1:9000

#### Reconfigure Nginx Config
Video [https://youtu.be/hG9oVbAL-BE?t=1319](https://youtu.be/hG9oVbAL-BE?t=1319) mulai menit 21:59

Seperti yang sudah dibicarakan sebelumnya bahwa Nginx perlu sebuah "media" untuk memproses PHP melalui php-fpm, maka kita perlu mengkonfigurasi ulang settingan Nginx.
Settingan Nginx (dengan metode yum) secara default berda pada direktori `/etc/nginx`.

Edit file `/etc/nginx/conf.d/default.conf` dan tambahkan konfigurasi berikut di antara instruksi `server{ }`

```
location ~* \.php$ {
  fastcgi_pass    127.0.0.1:9000;
  include         fastcgi_params;
  fastcgi_param   SCRIPT_FILENAME    $document_root$fastcgi_script_name;
  fastcgi_param   SCRIPT_NAME        $fastcgi_script_name;
}
```

jangan lupa tambahkan konfigurasi berikut diantara instruksi `location / {}` untuk memerintahkan Nginx memproses index.php atau index.html saat mengakses setiap direktori :
```
index    index.php index.html;
```
Sehingga kurang lebih konfigurasi file `/etc/nginx/conf.d/default.conf` menjadi seperti :
```
server {
    listen       80 default_server;
    listen       [::]:80 default_server;
    server_name  _;
    root         /usr/share/nginx/html;

    # Load configuration files for the default server block.
    include /etc/nginx/default.d/*.conf;

    location / {
	index    index.php index.html;
    }

    error_page 404 /404.html;
        location = /40x.html {
    }

    error_page 500 502 503 504 /50x.html;
        location = /50x.html {
    }

    location ~* \.php$ {
        fastcgi_pass 127.0.0.1:9000;
        include         fastcgi_params;
        fastcgi_param   SCRIPT_FILENAME    $document_root$fastcgi_script_name;
        fastcgi_param   SCRIPT_NAME        $fastcgi_script_name;
    }

}
```

Perhatikan konfigurasi `root         /usr/share/nginx/html;`, itu adalah root folder dimana nginx akan memberikan request kepada client (pengunjung).

Lebih detail : [https://www.linode.com/docs/web-servers/nginx/serve-php-php-fpm-and-nginx/](https://www.linode.com/docs/web-servers/nginx/serve-php-php-fpm-and-nginx/)

Jauh lebih detail : [nginx Documentation]

Setelah itu, restart Nginx service :
```bash
service nginx restart
```

kemudian, buat file php, yang berisi salah 1 fungsi PHP (hanya untuk memastikan bahwa PHP sudah dapat berjalan pada server kita).

Misalnya kita akan buat file info.php tepat pada default root direktori Nginx (/usr/share/nginx/html)
```bash
echo '<?php phpinfo(); ?>' > /usr/share/nginx/html/info.php
```

coba akses http://IPADDRSERVER/info.php , pastikan file PHP tereksekusi (menampilkan informasi detail tentang PHP pada server).

#### Installasi WordPress
Video : https://www.youtube.com/watch?v=umFxK0--HRg

Langkah terakhir adalah, menginstall CMS WordPress.

Download latest release dari wordpress.org.
File yang didownload bisa berupa .zip ataupun .tar.gz (seperti pada video, file berbentuk tar.gz)
Pada langah di sini, akan mendownload format .zip menggunakan wget.
(note, install unzip menggunakan yum untuk menggunakan perintah unzip)
```bash
yum install -y unzip
cd /usr/share/nginx/html
wget https://wordpress.org/latest.zip
unzip latest.zip
```
Setelah proses extract, maka program WordPress akan ada pada folder /usr/share/nginx/html/wordpress yang artinya kita dapat mengaksesnya melalui http://IPADDRSERVER/wordpress/

Jika ada pesan semacam : `Your PHP installation appears to be missing the MySQL extension which is required by WordPress.` artinya extensi MySQL dari program php belum diinstall (ekstensi tersebut dibutuhkan oleh program WordPress), install terlebih dahulu menggunakan :

```bash
yum install -y php73-php-pdo php73-php-mysqlnd
```
kemudian (selalu) restart php-fpm setelah menginstall ekstensi php baru supaya ekstensi tersebut berjalan.
```bash
service php73-php-fpm restart
```
Setelah itu coba reload browser.
Note : jalankan perintah berikut supaya php-fpm dapat menulis (read-write) direktori instalasi wordpress :
```bash
chown -R apache:apache /usr/share/nginx/html/wordpress
```

#### Buat Database dan User untuk WordPress
Supaya instalasi wordpress bisa berjalan, buat database untuk wordpress beserta user dan password untuk database tersebut :
Masuk ke database MySQL :
```bash
mysql -h localhost -u root -p
```
Masukkan password root yang sudah kita konfigurasi sebelumnya dari `mysql_secure_installation`.

Buat database bernama "wordpress"
```sql
CREATE DATABASE IF NOT EXISTS wordpress;
```
Buat MySQL User (dalam hal ini `wpuser` di `localhost` dengan password `wppass123`)
```sql
CREATE USER 'wpuser'@'localhost' IDENTIFIED BY 'wppass123';
```

Berikan semua permission untuk user `'wpuser'@'localhost'` ke database `wordpress`
```sql
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'localhost';
```
dan terakhir reload opsi grant yang baru saja kita berikan tadi dengan perintah :

```sql
FLUSH PRIVILEGES;
exit; #untuk keluar MySQL interface
```

Proses pembuatan database untuk telah selesai, ikuti proses instalasi WordPress dengan memberikan informasi user dan password serta database yang baru saja kita buat.

Selesai.

--

Script `bash` sederhana untuk instalaasi PHP, MySQL, dan Nginx dapat diakses di [scripts/install.sh](scripts/install.sh).
Script tersebut hanya installasi dasar, tidak termasuk konfigurasi.

## Glossary
[To Be Updated]
<!--
yum   
chkconfig   
rpm   
service
-->

## Resources
* [Dokumentasi Proxmox] [proxmox documentation]
* [Penjelasan mengenai UNIX file permission](https://devilzc0de.id/forum/thread-12656.html)
* [Tutor Video Instalasi Nginx latest stable version dari sourcecode dan spawn-fcgi](https://devilzc0de.id/forum/thread-9865.html) (tutorial lama 2011)


[proxmox documentation]: https://pve.proxmox.com/pve-docs/
[epel]: https://fedoraproject.org/wiki/EPEL
[remi]: https://rpms.remirepo.net/
[nginx Documentation]: https://nginx.org/en/docs/

## Lisensi
[MIT License](LICENSE)
