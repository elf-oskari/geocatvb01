# #############################################
# geocatvb01 geonetwork service setup bootstrap
# #############################################
# CHANGES
#
# 2014-10-28 
# - (/) 'self documenting' - added comments to this
# - (/) new approach to migrating
#    1) import dump
#    2) migrate
#    3) restore default settings from 2103 dump
#    4) migrate settings
#
# 2014-10-21 targets
# - (/) fix PostGIS installation issues (ok)
# - (x) try to get PostGIS spatial index to work
# - (/) upgrade to geonetwork 2.10.3 atomfeed version (ok)
# - (/) fix migration scripts from 2.6.5 to 2.8.0 to 2.10.3 OR  (some missing db tables for 2.10.3 inspireatomfeed found from H2 db with DESCRIBE )
# - (/) setup for schema catalogue  WAR and db (ok)
# - (-) setup for metadata printout WAR and db (only partial success printout (deegree 2.x) sends CSW request without service="CSW" attribute -fails)
# 
# 2014-09-18
# - initial bootstrap for geonetwork geo catalogue
#

# 0) setup and versions
set -e -u

JETTY_RELEASE=stable-9
JETTY_VERSION=9.2.3.v20140905
GEONETWORK_WAR_URL=http://thor.geocat.net/downloads/geonetwork-2103-atomfeed.war
GEONETWORK_DB_DUMP=/vagrant/resources/geonetwork265inspire_20140917.sql

CATALOGUE_DB_DUMP_SRC=http://geonetwork.nls.fi/dist/catalogue_20140917.sql
CATALOGUE_HTML_TAR_SRC=http://geonetwork.nls.fi/dist/catalogue-html.tgz

WEBSERVICES_TAR_SRC=http://geonetwork.nls.fi/dist/webservices.tgz


# 1) TOOLS
printf "1) Tools\n"
sudo yum -y install unzip

# 2) Database services
printf "1) Database PostgreSQL\n"
# 2.1) PostgreSQL 
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

# PostgreSQL - database setup and config
sudo service postgresql-9.3 initdb

sudo sed '/^local.*/s/peer/trust/g' /var/lib/pgsql/9.3/data/pg_hba.conf > TEMP_pg_hba.conf
sudo sed '/.*127\.0\.0\.1.*/s/ident/trust/g' TEMP_pg_hba.conf > TEMP_pg_hba2.conf
# sudo diff /var/lib/pgsql/9.3/data/pg_hba.conf  TEMP_pg_hba2.conf
sudo cp /var/lib/pgsql/9.3/data/pg_hba.conf /var/lib/pgsql/9.3/data/pg_hba.conf.backup
sudo cp TEMP_pg_hba2.conf /var/lib/pgsql/9.3/data/pg_hba.conf

sudo chkconfig postgresql-9.3 on
#sudo service postgresql-9.3 start

# 3) Runtime
printf "3) Runtime JDK\n"
# 3.1) JDK
sudo yum -y install java-1.7.0-openjdk

# 4) Application services
printf "4) Application services - NGINGX\n"
# 4.1) Nginx
#sudo su -c 'rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm'
sudo yum -y install nginx

# 4.2) Jetty
printf "4) Application services - Jetty\n"
wget -q --output-document=jetty-distribution-$JETTY_VERSION.tar.gz http://download.eclipse.org/jetty/$JETTY_RELEASE/dist/jetty-distribution-$JETTY_VERSION.tar.gz
wget -q --output-document=jetty-distribution-$JETTY_VERSION.tar.gz.sha1 http://download.eclipse.org/jetty/$JETTY_RELEASE/dist/jetty-distribution-$JETTY_VERSION.tar.gz.sha1

sudo mkdir /opt/jetty
sudo tar xzf jetty-distribution-$JETTY_VERSION.tar.gz -C /opt/jetty
sudo ln -s /opt/jetty/jetty-distribution-$JETTY_VERSION /opt/jetty9
sudo mkdir /opt/jetty9/work
sudo useradd jetty
sudo chown -R jetty:jetty /opt/jetty/jetty-distribution-$JETTY_VERSION
sudo cp /opt/jetty9/bin/jetty.sh /etc/init.d/jetty
sudo chkconfig --add jetty
sudo chkconfig jetty on
sudo mkdir /var/log/jetty
sudo chown jetty:jetty /var/log/jetty
sudo printf 'JETTY_HOME=/opt/jetty9\nJETTY_USER=jetty\nJETTY_LOGS=/var/log/jetty' > /etc/default/jetty

# 4.3) PostgreSQL support for Jetty
# jdbc libs to be shared from Jetty lib/ext
wget -q --output-document=postgresql-9.3-1102.jdbc3.jar http://jdbc.postgresql.org/download/postgresql-9.3-1102.jdbc3.jar
wget -q --output-document=postgresql-9.3-1102.jdbc4.jar  http://jdbc.postgresql.org/download/postgresql-9.3-1102.jdbc4.jar
#sudo mv postgresql-9.3-1102.jdbc3.jar /opt/jetty9/webapps/geonetwork/WEB-INF/lib/
#sudo mv postgresql-9.3-1102.jdbc4.jar /opt/jetty9/webapps/geonetwork/WEB-INF/lib/
sudo mv postgresql-9.3-1102.jdbc3.jar /opt/jetty9/lib/ext/
sudo mv postgresql-9.3-1102.jdbc4.jar /opt/jetty9/lib/ext/


# 5) Configs
printf "5) Database startup\n"
# 5.1) work dir
cd /tmp/

# 5.2) DB startup
sudo service postgresql-9.3 start

# 6) Geonetwork Database content
printf "6) Database content\n"


# 6.1) Geonetwork Database
printf "6.1...6.3) Database content - Geonetwork\n"
sudo -u postgres psql -d postgres <<EOF
CREATE DATABASE geonetwork_2_10 WITH OWNER = postgres ENCODING = 'UTF8' TABLESPACE = pg_default CONNECTION LIMIT = -1;
\c geonetwork_2_10
CREATE EXTENSION POSTGIS;
EOF

# 6.2) APP create DB roles
sudo -u postgres psql -d geonetwork_2_10 <<EOF
CREATE ROLE jetty LOGIN;
CREATE ROLE geonetwork LOGIN;
CREATE ROLE web LOGIN;
EOF


# 6.3) initialise Geonetwork database from a dump
sudo -u postgres psql -d geonetwork_2_10 -f $GEONETWORK_DB_DUMP


# 6.4) tailored SQL migration for Geonetwork 2.6.5 -> 2.8 -> 2.10
# - 2.10.3 atomfeed version requires some additions not available in github for PostgreSQL
printf "6.4) Database content - Geonetwork migrations\n"
sudo -u postgres psql -d geonetwork_2_10 -f /vagrant/resources/v280-migrate-default.sql
sudo -u postgres psql -d geonetwork_2_10 -f /vagrant/resources/v2100-migrate-default.sql
sudo -u postgres psql -d geonetwork_2_10 -f /vagrant/resources/2103-settings-post-migrate.sql

# 6.5) GRANTS for geonetwork db
sudo -u postgres psql -d geonetwork_2_10 <<EOF
grant SELECT,INSERT,UPDATE,DELETE,REFERENCES,TRIGGER ON ALL TABLES IN SCHEMA PUBLIC TO geonetwork;
grant SELECT,INSERT,UPDATE,DELETE,REFERENCES,TRIGGER ON ALL TABLES IN SCHEMA PUBLIC TO jetty;
EOF


# 7) Catalogue Database Content
printf "7) Database content - Catalogue\n"
# 7.1) catalogue Database Creation
wget -q --output-document=catalogue_20140917.sql $CATALOGUE_DB_DUMP_SRC
sudo -u postgres psql -d postgres <<EOF
CREATE DATABASE catalogue WITH OWNER = web ENCODING = 'UTF8' TABLESPACE = pg_default CONNECTION LIMIT = -1;
EOF

# 7.2) catalogue database content from a snapshot
sudo -u postgres psql -d catalogue -f catalogue_20140917.sql


# 8) Web App - Geonetwork
printf "8) WebApp - Geonetwork\n"
# 8.1) Geonetwork WAR 2.10.3 atomfeed version
#wget -q --output-document=geonetwork-210-atomfeed.zip http://geonetwork.nls.fi/dist/geonetwork/geonetwork-210-atomfeed.zip
wget -q --output-document=geonetwork-210-atomfeed.zip $GEONETWORK_WAR_URL

# 8.2) Geonetwork Configuration overrides

sudo mkdir /opt/jetty9/webapps/geonetwork
sudo unzip -q geonetwork-210-atomfeed.zip -d /opt/jetty9/webapps/geonetwork
sudo cp /opt/jetty9/webapps/geonetwork/WEB-INF/config.xml /opt/jetty9/webapps/geonetwork/WEB-INF/config.xml.backup
sudo cp /vagrant/resources/geonetwork-config.xml /opt/jetty9/webapps/geonetwork/WEB-INF/config.xml

# 8.3) Geonetwork default icu4j fails  on most JVM + Jetty setups - upgrade
sudo cp /vagrant/resources/icu4j_2_8.jar /opt/jetty9/webapps/geonetwork/WEB-INF/lib/
sudo rm  /opt/jetty9/webapps/geonetwork/WEB-INF/lib/icu4j-2.6.1.jar 

# 8.4) ensure owner 
sudo chown -R jetty:jetty /opt/jetty9/webapps/geonetwork


# 9) Catalogue WEBAPP and related
printf "9) WebApp - Catalogue etc\n"
# 9.1) HTML files
wget -q --output-document=catalogue-html.tgz $CATALOGUE_HTML_TAR_SRC
sudo tar xzfC catalogue-html.tgz /usr/share/nginx/html
sudo chown -R nginx:root /usr/share/nginx/html/catalogue

# 9.2) WARs
wget -q --output-document=webservices.tgz $WEBSERVICES_TAR_SRC
sudo mkdir /tmp/_ws
sudo tar xzfC webservices.tgz /tmp/_ws

# 9.3) schema catalogue
sudo cp /tmp/_ws/webservices/webapps/portti-schema-service.war /opt/jetty9/webapps/
sudo chown jetty:jetty /opt/jetty9/webapps/portti-schema-service.war


# 10) validator jump station
printf "10) WebApp - Validator redirection\n"
sudo cp /tmp/_ws/webservices/webapps/validator-geoportal-fi-0.0.1-SNAPSHOT.war /opt/jetty9/webapps/
sudo chown jetty:jetty /opt/jetty9/webapps/validator-geoportal-fi-0.0.1-SNAPSHOT.war


# 11) metadata printout
# - let's not - missing multi language support etc. geonetwork has some support for printing metadata
#printf "11) WebApp - Metadata Printout\n"
#sudo mkdir jetty:jetty /opt/jetty9/webapps/portti-metadata-printout
#sudo unzip -q /tmp/_ws/webservices/webapps/portti-metadata-printout.war -d /opt/jetty9/webapps/portti-metadata-printout
#sudo cp /vagrant/resources/portti-metadata-printout-web.xml /opt/jetty9/webapps/portti-metadata-printout/WEB-INF/web.xml
#sudo chown -R jetty:jetty /opt/jetty9/webapps/portti-metadata-printout


# 12) App NGINX Setup
printf "12) WebApp - Nginx configuration\n"
sudo mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.backup
sudo cp /vagrant/resources/geocat-nginx.conf /etc/nginx/conf.d/geocat.conf


## 13) Vagrant test setup
printf "13) Vagrant test settings to Geonetwork\n"
sudo -u postgres psql -d geonetwork_2_10 <<EOF
update Settings set value = 'localhost' where name = 'host' and id = 21;
update Settings set value = '8080' where name = 'port' and id = 22;
EOF

printf "14) Done.\n"
printf "15) Start services with\n-> vagrant ssh\n---> sudo service jetty start\n---> sudo service nginx start\n\n"
# 14) SERVICE startup
#sudo service jetty start
#sudo service nginx start


