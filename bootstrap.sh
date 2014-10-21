# #############################################
# geocatvb01 geonetwork service setup bootstrap
# #############################################
# CHANGES
#
# 2014-10-21 targets
# - (/) fix PostGIS installation issues
# - (/) upgrade to geonetwork 2.10.3 atomfeed version
# - (x) fix migration scripts from 2.6.5 to 2.8.0 to 2.10.3 OR 
# - (x) ? modify data to enable Geonetwork migrations to work?
# - (x) setup for schema catalogue  WAR and db
# - (x) setup for metadata printout WAR and db
# 
# 2014-09-18
# - initial bootstrap for geonetwork geo catalogue
#

# TOOLS
sudo yum -y install unzip


# PostgreSQL 
sudo sed '/\[.*\]/ a\
exclude=postgresql*' /etc/yum.repos.d/CentOS-Base.repo > TEMP-CentOS-Base.repo
sudo cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
sudo cp TEMP-CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo

sudo yum -y localinstall http://www.nic.funet.fi/pub/mirrors/fedora.redhat.com/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
sudo yum -y localinstall http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-centos93-9.3-1.noarch.rpm
sudo yum -y list postgres*

sudo yum -y install gdal geos libxml2 json-c
sudo yum -y install postgresql93-server postgresql-contrib
sudo yum -y install postgis2_93


sudo service postgresql-9.3 initdb

sudo sed '/^local.*/s/peer/trust/g' /var/lib/pgsql/9.3/data/pg_hba.conf > TEMP_pg_hba.conf
sudo sed '/.*127\.0\.0\.1.*/s/ident/trust/g' TEMP_pg_hba.conf > TEMP_pg_hba2.conf
sudo diff /var/lib/pgsql/9.3/data/pg_hba.conf  TEMP_pg_hba2.conf
sudo cp /var/lib/pgsql/9.3/data/pg_hba.conf /var/lib/pgsql/9.3/data/pg_hba.conf.backup
sudo cp TEMP_pg_hba2.conf /var/lib/pgsql/9.3/data/pg_hba.conf

sudo chkconfig postgresql-9.3 on
#sudo service postgresql-9.3 start

# Nginx
#sudo su -c 'rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm'
sudo yum -y install nginx

# JDK
sudo yum -y install java-1.7.0-openjdk

# Jetty
wget -q --output-document=jetty-distribution-9.2.3.v20140905.tar.gz http://download.eclipse.org/jetty/stable-9/dist/jetty-distribution-9.2.3.v20140905.tar.gz
wget -q --output-document=jetty-distribution-9.2.3.v20140905.tar.gz.sha1 http://download.eclipse.org/jetty/stable-9/dist/jetty-distribution-9.2.3.v20140905.tar.gz.sha1

sudo mkdir /opt/jetty
sudo tar xzf jetty-distribution-9.2.3.v20140905.tar.gz -C /opt/jetty
sudo ln -s /opt/jetty/jetty-distribution-9.2.3.v20140905 /opt/jetty9
sudo mkdir /opt/jetty9/work
sudo useradd jetty
sudo chown -R jetty:jetty /opt/jetty/jetty-distribution-9.2.3.v20140905
sudo cp /opt/jetty9/bin/jetty.sh /etc/init.d/jetty
sudo chkconfig --add jetty
sudo chkconfig jetty on
sudo mkdir /var/log/jetty
sudo chown jetty:jetty /var/log/jetty
sudo printf 'JETTY_HOME=/opt/jetty9\nJETTY_USER=jetty\nJETTY_LOGS=/var/log/jetty' > /etc/default/jetty

# DB 
sudo service postgresql-9.3 start

cd /tmp/

# APP create DB
sudo -u postgres psql -d postgres <<EOF
CREATE DATABASE geonetwork_2_10 WITH OWNER = postgres ENCODING = 'UTF8' TABLESPACE = pg_default CONNECTION LIMIT = -1;
\c geonetwork_2_10
CREATE EXTENSION POSTGIS;
EOF

# APP create DB roles
sudo -u postgres psql -d geonetwork_2_10 <<EOF
CREATE ROLE jetty LOGIN;
CREATE ROLE geonetwork LOGIN;
CREATE ROLE web LOGIN;
EOF

# APP create DB geonetwork_2_10 content
sudo -u postgres psql -d geonetwork_2_10 -f /vagrant/resources/geonetwork265inspire_20140917.sql


## APP SQL migrate 2.6.5 -> 2.10
sudo -u postgres psql -d geonetwork_2_10 -f /vagrant/resources/v280-migrate-default.sql
sudo -u postgres psql -d geonetwork_2_10 -f /vagrant/resources/v2100-migrate-default.sql

# GRANTS
sudo -u postgres psql -d geonetwork_2_10 <<EOF
grant SELECT,INSERT,UPDATE,DELETE,REFERENCES,TRIGGER ON ALL TABLES IN SCHEMA PUBLIC TO geonetwork;
grant SELECT,INSERT,UPDATE,DELETE,REFERENCES,TRIGGER ON ALL TABLES IN SCHEMA PUBLIC TO jetty;
EOF


## Vagrant test setup
sudo -u postgres psql -d geonetwork_2_10 <<EOF
update Settings set value = 'localhost' where name = 'host' and id = 21;
update Settings set value = '8080' where name = 'port' and id = 22;
EOF

# APP GEONETWORK WAR
#wget -q --output-document=geonetwork-210-atomfeed.zip http://geonetwork.nls.fi/dist/geonetwork/geonetwork-210-atomfeed.zip
wget -q --output-document=geonetwork-210-atomfeed.zip http://thor.geocat.net/downloads/geonetwork-2103-atomfeed.war
# APP GEONETWORK CONF
# - overrides or extracted WAR?
sudo mkdir /opt/jetty9/webapps/geonetwork
sudo unzip -q geonetwork-210-atomfeed.zip -d /opt/jetty9/webapps/geonetwork
sudo cp /opt/jetty9/webapps/geonetwork/WEB-INF/config.xml /opt/jetty9/webapps/geonetwork/WEB-INF/config.xml.backup
sudo cp /vagrant/resources/geonetwork-config.xml /opt/jetty9/webapps/geonetwork/WEB-INF/config.xml

# fixes
sudo cp /vagrant/resources/icu4j_2_8.jar /opt/jetty9/webapps/geonetwork/WEB-INF/lib/
sudo rm  /opt/jetty9/webapps/geonetwork/WEB-INF/lib/icu4j-2.6.1.jar 

# jdbc
wget -q --output-document=postgresql-9.3-1102.jdbc3.jar http://jdbc.postgresql.org/download/postgresql-9.3-1102.jdbc3.jar
wget -q --output-document=postgresql-9.3-1102.jdbc4.jar  http://jdbc.postgresql.org/download/postgresql-9.3-1102.jdbc4.jar
sudo mv postgresql-9.3-1102.jdbc3.jar /opt/jetty9/webapps/geonetwork/WEB-INF/lib/
sudo mv postgresql-9.3-1102.jdbc4.jar /opt/jetty9/webapps/geonetwork/WEB-INF/lib/




# ensure owner
sudo chown -R jetty:jetty /opt/jetty9/webapps/geonetwork




# APP NGINX CONF AND FILES
# - HTML files
# - proxy settings
sudo tar xzfC /vagrant/resources/catalogue-html.tgz /usr/share/nginx/html
sudo mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.backup
sudo cp /vagrant/resources/geocat-nginx.conf /etc/nginx/conf.d/geocat.conf


# SERVICE startup
#sudo service jetty start
#sudo service nginx start

