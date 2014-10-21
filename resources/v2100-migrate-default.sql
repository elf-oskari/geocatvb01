-- ======================================================================

ALTER TABLE Users ADD COLUMN security VARCHAR(128) default '';
ALTER TABLE Users ADD COLUMN authtype VARCHAR(32);
ALTER TABLE users ALTER "password" TYPE character varying(120);
-- ======================================================================

-- Support multiple profiles per user
ALTER TABLE usergroups ADD profile varchar(32);
UPDATE usergroups SET profile = (SELECT profile from users WHERE id = userid);
ALTER TABLE usergroups DROP CONSTRAINT usergroups_pkey;
ALTER TABLE usergroups ADD PRIMARY KEY (userid, profile, groupid);

ALTER TABLE Metadata ALTER harvestUri TYPE varchar(512);

-- ALTER TABLE HarvestHistory ADD elapsedTime int;

CREATE TABLE Services
(

    id         int,
    name       varchar(64)   not null,
    class       varchar(1048)   not null,
    description       varchar(1048),

    primary key(id)
);


CREATE TABLE ServiceParameters
(
    id         int,
    service     int,
    name       varchar(64)   not null,
    value       varchar(1048)   not null,

    primary key(id),

    foreign key(service) references Services(id)
);
-- ======================================================================




-- Spring security
UPDATE Users SET security='update_hash_required';

-- Delete LDAP settings
DELETE FROM Settings WHERE parentid=86;
DELETE FROM Settings WHERE parentid=87;
DELETE FROM Settings WHERE parentid=89;
DELETE FROM Settings WHERE parentid=80;
DELETE FROM Settings WHERE id=80;

-- New settings 
--INSERT INTO Settings VALUES (24,20,'securePort','8443');
INSERT INTO Settings VALUES (1956,1,'hidewithheldelements',NULL);
INSERT INTO Settings VALUES (1957,1956,'enable','false');
INSERT INTO Settings VALUES (1958,1956,'keepMarkedElement','true');
INSERT INTO Settings VALUES (1955,952,'ignored','true');

-- INSERT INTO Settings VALUES (723,720,'atom','remote');
-- INSERT INTO Settings VALUES (724,720,'atomSchedule','0 0 0/24 ? * *');
-- INSERT INTO Settings VALUES (725,720,'atomProtocol','INSPIRE-ATOM');

-- Version update
UPDATE Settings SET value='2.10.0' WHERE name='version';
UPDATE Settings SET value='SNAPSHOT' WHERE name='subVersion';

UPDATE HarvestHistory SET elapsedTime = 0 WHERE elapsedTime IS NULL;

-- MISSING TABLES


CREATE TABLE inspireatomfeed
(

    id         int not null,
    metadataid int not null,
    atom text,
    atomurl       varchar(255),
    atomdatasetid       varchar(250),
    atomdatasetns       varchar(250),
    title       varchar(250),
    subtitle       varchar(250),
    rights       varchar(250),
    lang       varchar(3),
    authorname       varchar(250),
    authoremail       varchar(250),

    primary key(id)
);

    -- from H2 with H2 Console 
    -- java -cp /opt/jetty9/webapps/geonetwork/WEB-INF/lib/h2*.jar org.h2.tools.Shell
-- sql> describe INSPIREATOMFEED
-- Column Name                     |Type          |Precision  |Nullable|Default
-- ID                              |INTEGER       |10         |NO      |null
-- METADATAID                      |INTEGER       |10         |NO      |null
-- ATOM                            |VARCHAR       |2147483647 |YES     |null
-- ATOMURL                         |VARCHAR       |255        |YES     |null
-- ATOMDATASETID                   |VARCHAR       |250        |YES     |null
-- ATOMDATASETNS                   |VARCHAR       |250        |YES     |null
-- TITLE                           |VARCHAR       |250        |YES     |null
-- SUBTITLE                        |VARCHAR       |250        |YES     |null
-- RIGHTS                          |VARCHAR       |250        |YES     |null
-- LANG                            |VARCHAR       |3          |YES     |null
-- AUTHORNAME                      |VARCHAR       |250        |YES     |null
-- AUTHOREMAIL                     |VARCHAR       |250        |YES     |null

CREATE TABLE inspireatomfeedentries
(

    id         int not null,
    inspireatomfeedid int not null,
    datasetuuid varchar(250) not null,
    title       varchar(250),
    lang       varchar(3),
    type        varchar(250),
    url       varchar(250),
    crs       varchar(250),

    primary key(id)
);

-- from H2 with H2 Console 
-- java -cp /opt/jetty9/webapps/geonetwork/WEB-INF/lib/h2*.jar org.h2.tools.Shell
-- sql> DESCRIBE INSPIREATOMFEEDENTRIES
-- Column Name                     |Type          |Precision  |Nullable|Default
-- ID                              |INTEGER       |10         |NO      |null
-- INSPIREATOMFEEDID               |INTEGER       |10         |NO      |null
-- DATASETUUID                     |VARCHAR       |250        |NO      |null
-- TITLE                           |VARCHAR       |250        |YES     |null
-- LANG                            |VARCHAR       |3          |YES     |null
-- TYPE                            |VARCHAR       |250        |YES     |null
-- URL                             |VARCHAR       |250        |YES     |null
-- CRS                             |VARCHAR       |250        |YES     |null
