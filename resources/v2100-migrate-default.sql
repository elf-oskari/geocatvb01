-- ======================================================================

ALTER TABLE Users ADD COLUMN security VARCHAR(128) default '';
ALTER TABLE Users ADD COLUMN authtype VARCHAR(32);
-- ======================================================================

-- ======================================================================

CREATE TABLE HarvestHistory
  (
    id             int           not null,
    harvestDate    varchar(30),
    elapsedTime    int,
    harvesterUuid  varchar(250),
    harvesterName  varchar(128),
    harvesterType  varchar(128),
    deleted        char(1)       default 'n' not null,
    info           text,
    params         text,

    primary key(id)

  );

CREATE INDEX HarvestHistoryNDX1 ON HarvestHistory(harvestDate);


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
