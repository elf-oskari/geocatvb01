-- ======================================================================

ALTER TABLE IsoLanguages ADD COLUMN shortcode VARCHAR(2);

-- ======================================================================

-- =====
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

CREATE TABLE StatusValues
(
    id        int not null,
    name      varchar(32)   not null,
    reserved  char(1)       default 'n' not null,
    primary key(id)
);


CREATE TABLE StatusValuesDes
(
    idDes   int not null,
    langId  varchar(5) not null,
    label   varchar(96)   not null,
    primary key(idDes,langId)
);


CREATE TABLE MetadataStatus
(
    metadataId  int not null,
    statusId    int default 0 not null,
    userId      int not null,
    changeDate   varchar(30)    not null,
    changeMessage   varchar(2048) not null,
    primary key(metadataId,statusId,userId,changeDate),
    foreign key(metadataId) references Metadata(id),
    foreign key(statusId)   references StatusValues(id),
    foreign key(userId)     references Users(id)
);
CREATE INDEX MetadataNDX3 ON Metadata(owner);

CREATE TABLE Validation
(
    metadataId   int,
    valType      varchar(40),
    status       int,
    tested       int,
    failed       int,
    valDate      varchar(30),

    primary key(metadataId, valType),
    foreign key(metadataId) references Metadata(id)
);

CREATE TABLE Thesaurus (
    id   varchar(250) not null,
    activated    varchar(1),
    primary key(id)
);

ALTER TABLE Users ALTER COLUMN username TYPE varchar(256);

ALTER TABLE Metadata ALTER COLUMN createDate TYPE varchar(30);
ALTER TABLE Metadata ALTER COLUMN changeDate TYPE varchar(30);
ALTER TABLE Metadata ADD doctype varchar(255);

DROP TABLE IndexLanguages;

ALTER TABLE Languages DROP COLUMN isocode;

ALTER TABLE IsoLanguages ADD shortcode varchar(2);

ALTER TABLE Categories ALTER COLUMN  name TYPE varchar(255);
ALTER TABLE CategoriesDes ALTER COLUMN label TYPE varchar(255);
ALTER TABLE Settings ALTER COLUMN name TYPE varchar(64);

-- =====


-- INSERT INTO Settings VALUES (910,1,'metadata',NULL);
-- INSERT INTO Settings VALUES (911,910,'enableSimpleView','true');
-- INSERT INTO Settings VALUES (912,910,'enableIsoView','true');
-- INSERT INTO Settings VALUES (913,910,'enableInspireView','false');
-- INSERT INTO Settings VALUES (914,910,'enableXmlView','true');
-- INSERT INTO Settings VALUES (915,910,'defaultView','simple');

INSERT INTO Settings VALUES (1917,1,'metadataprivs',NULL);
INSERT INTO Settings VALUES (1918,1917,'usergrouponly','false');

INSERT INTO Settings VALUES (1920,1,'threadedindexing',NULL);
INSERT INTO Settings VALUES (1921,1920,'maxthreads','1');
INSERT INTO Settings VALUES (17,10,'svnUuid','');

-- add extra placeholders for shibboleth attributes

INSERT INTO Settings VALUES (180,173,'organizationName',NULL);
INSERT INTO Settings VALUES (181,173,'postalAddress',NULL);
INSERT INTO Settings VALUES (182,173,'phone',NULL);
INSERT INTO Settings VALUES (183,173,'email',NULL);
INSERT INTO Settings VALUES (184,173,'fullName',NULL);

-- add requestedlanguage and autodetect settings

INSERT INTO Settings VALUES (1950,1,'autodetect',NULL);
INSERT INTO Settings VALUES (1951,1950,'enable','true');
INSERT INTO Settings VALUES (1952,1,'requestedLanguage',NULL);
INSERT INTO Settings VALUES (1953,1952,'only','prefer_locale');
INSERT INTO Settings VALUES (1954,1952,'sorted','true');

-- add enable statistics
INSERT INTO Settings VALUES (1250,1,'searchStats',NULL);
INSERT INTO Settings VALUES (251,1250,'enable','false');


-- delete indexlanguages settings
-- Remove third level settings
DELETE FROM Settings WHERE id = 802;
DELETE FROM Settings WHERE id = 803;
DELETE FROM Settings WHERE id = 805;
DELETE FROM Settings WHERE id = 806;
DELETE FROM Settings WHERE id = 808;
DELETE FROM Settings WHERE id = 809;
DELETE FROM Settings WHERE id = 811;
DELETE FROM Settings WHERE id = 812;
DELETE FROM Settings WHERE id = 814;
DELETE FROM Settings WHERE id = 815;
DELETE FROM Settings WHERE id = 817;
DELETE FROM Settings WHERE id = 818;
DELETE FROM Settings WHERE id = 820;
DELETE FROM Settings WHERE id = 821;
DELETE FROM Settings WHERE id = 823;
DELETE FROM Settings WHERE id = 824;
DELETE FROM Settings WHERE id = 826;
DELETE FROM Settings WHERE id = 827;
DELETE FROM Settings WHERE id = 829;
DELETE FROM Settings WHERE id = 830;
DELETE FROM Settings WHERE id = 832;
DELETE FROM Settings WHERE id = 833;
DELETE FROM Settings WHERE id = 835;
DELETE FROM Settings WHERE id = 836;
DELETE FROM Settings WHERE id = 838;
DELETE FROM Settings WHERE id = 839;

-- Remove second level settings
DELETE FROM Settings WHERE id = 801;
DELETE FROM Settings WHERE id = 804;
DELETE FROM Settings WHERE id = 807;
DELETE FROM Settings WHERE id = 810;
DELETE FROM Settings WHERE id = 813;
DELETE FROM Settings WHERE id = 816;
DELETE FROM Settings WHERE id = 819;
DELETE FROM Settings WHERE id = 822;
DELETE FROM Settings WHERE id = 825;
DELETE FROM Settings WHERE id = 828;
DELETE FROM Settings WHERE id = 831;
DELETE FROM Settings WHERE id = 834;
DELETE FROM Settings WHERE id = 837;

-- Remove first level settings
DELETE FROM Settings WHERE id = 800;


UPDATE IsoLanguages SET shortcode='aa' WHERE code='aar';
UPDATE IsoLanguages SET shortcode='ab' WHERE code='abk';
UPDATE IsoLanguages SET shortcode='af' WHERE code='afr';
UPDATE IsoLanguages SET shortcode='ak' WHERE code='aka';
UPDATE IsoLanguages SET shortcode='sq' WHERE code='alb';
UPDATE IsoLanguages SET shortcode='am' WHERE code='amh';
UPDATE IsoLanguages SET shortcode='ar' WHERE code='ara';
UPDATE IsoLanguages SET shortcode='an' WHERE code='arg';
UPDATE IsoLanguages SET shortcode='hy' WHERE code='arm';
UPDATE IsoLanguages SET shortcode='as' WHERE code='asm';
UPDATE IsoLanguages SET shortcode='av' WHERE code='ava';
UPDATE IsoLanguages SET shortcode='ae' WHERE code='ave';
UPDATE IsoLanguages SET shortcode='ay' WHERE code='aym';
UPDATE IsoLanguages SET shortcode='az' WHERE code='aze';
UPDATE IsoLanguages SET shortcode='ba' WHERE code='bak';
UPDATE IsoLanguages SET shortcode='bm' WHERE code='bam';
UPDATE IsoLanguages SET shortcode='eu' WHERE code='baq';
UPDATE IsoLanguages SET shortcode='be' WHERE code='bel';
UPDATE IsoLanguages SET shortcode='bn' WHERE code='ben';
UPDATE IsoLanguages SET shortcode='bh' WHERE code='bih';
UPDATE IsoLanguages SET shortcode='bi' WHERE code='bis';
UPDATE IsoLanguages SET shortcode='bs' WHERE code='bos';
UPDATE IsoLanguages SET shortcode='br' WHERE code='bre';
UPDATE IsoLanguages SET shortcode='bg' WHERE code='bul';
UPDATE IsoLanguages SET shortcode='my' WHERE code='bur';
UPDATE IsoLanguages SET shortcode='ca' WHERE code='cat';
UPDATE IsoLanguages SET shortcode='ch' WHERE code='cha';
UPDATE IsoLanguages SET shortcode='ce' WHERE code='che';
UPDATE IsoLanguages SET shortcode='zh' WHERE code='chi';
UPDATE IsoLanguages SET shortcode='cu' WHERE code='chu';
UPDATE IsoLanguages SET shortcode='cv' WHERE code='chv';
UPDATE IsoLanguages SET shortcode='kw' WHERE code='cor';
UPDATE IsoLanguages SET shortcode='co' WHERE code='cos';
UPDATE IsoLanguages SET shortcode='cr' WHERE code='cre';
UPDATE IsoLanguages SET shortcode='cs' WHERE code='cze';
UPDATE IsoLanguages SET shortcode='da' WHERE code='dan';
UPDATE IsoLanguages SET shortcode='dv' WHERE code='div';
UPDATE IsoLanguages SET shortcode='nl' WHERE code='dut';
UPDATE IsoLanguages SET shortcode='dz' WHERE code='dzo';
UPDATE IsoLanguages SET shortcode='en' WHERE code='eng';
UPDATE IsoLanguages SET shortcode='eo' WHERE code='epo';
UPDATE IsoLanguages SET shortcode='et' WHERE code='est';
UPDATE IsoLanguages SET shortcode='ee' WHERE code='ewe';
UPDATE IsoLanguages SET shortcode='fo' WHERE code='fao';
UPDATE IsoLanguages SET shortcode='fj' WHERE code='fij';
UPDATE IsoLanguages SET shortcode='fi' WHERE code='fin';
UPDATE IsoLanguages SET shortcode='fr' WHERE code='fre';
UPDATE IsoLanguages SET shortcode='fy' WHERE code='fry';
UPDATE IsoLanguages SET shortcode='ff' WHERE code='ful';
UPDATE IsoLanguages SET shortcode='ka' WHERE code='geo';
UPDATE IsoLanguages SET shortcode='de' WHERE code='ger';
UPDATE IsoLanguages SET shortcode='gd' WHERE code='gla';
UPDATE IsoLanguages SET shortcode='ga' WHERE code='gle';
UPDATE IsoLanguages SET shortcode='gl' WHERE code='glg';
UPDATE IsoLanguages SET shortcode='gv' WHERE code='glv';
UPDATE IsoLanguages SET shortcode='el' WHERE code='gre';
UPDATE IsoLanguages SET shortcode='gn' WHERE code='grn';
UPDATE IsoLanguages SET shortcode='gu' WHERE code='guj';
UPDATE IsoLanguages SET shortcode='ht' WHERE code='hat';
UPDATE IsoLanguages SET shortcode='ha' WHERE code='hau';
UPDATE IsoLanguages SET shortcode='he' WHERE code='heb';
UPDATE IsoLanguages SET shortcode='hz' WHERE code='her';
UPDATE IsoLanguages SET shortcode='hi' WHERE code='hin';
UPDATE IsoLanguages SET shortcode='ho' WHERE code='hmo';
UPDATE IsoLanguages SET shortcode='hu' WHERE code='hun';
UPDATE IsoLanguages SET shortcode='ig' WHERE code='ibo';
UPDATE IsoLanguages SET shortcode='is' WHERE code='ice';
UPDATE IsoLanguages SET shortcode='io' WHERE code='ido';
UPDATE IsoLanguages SET shortcode='ii' WHERE code='iii';
UPDATE IsoLanguages SET shortcode='iu' WHERE code='iku';
UPDATE IsoLanguages SET shortcode='ie' WHERE code='ile';
UPDATE IsoLanguages SET shortcode='ia' WHERE code='ina';
UPDATE IsoLanguages SET shortcode='id' WHERE code='ind';
UPDATE IsoLanguages SET shortcode='ik' WHERE code='ipk';
UPDATE IsoLanguages SET shortcode='it' WHERE code='ita';
UPDATE IsoLanguages SET shortcode='jv' WHERE code='jav';
UPDATE IsoLanguages SET shortcode='ja' WHERE code='jpn';
UPDATE IsoLanguages SET shortcode='kl' WHERE code='kal';
UPDATE IsoLanguages SET shortcode='kn' WHERE code='kan';
UPDATE IsoLanguages SET shortcode='ks' WHERE code='kas';
UPDATE IsoLanguages SET shortcode='kr' WHERE code='kau';
UPDATE IsoLanguages SET shortcode='kk' WHERE code='kaz';
UPDATE IsoLanguages SET shortcode='km' WHERE code='khm';
UPDATE IsoLanguages SET shortcode='ki' WHERE code='kik';
UPDATE IsoLanguages SET shortcode='rw' WHERE code='kin';
UPDATE IsoLanguages SET shortcode='ky' WHERE code='kir';
UPDATE IsoLanguages SET shortcode='kv' WHERE code='kom';
UPDATE IsoLanguages SET shortcode='kg' WHERE code='kon';
UPDATE IsoLanguages SET shortcode='ko' WHERE code='kor';
UPDATE IsoLanguages SET shortcode='kj' WHERE code='kua';
UPDATE IsoLanguages SET shortcode='ku' WHERE code='kur';
UPDATE IsoLanguages SET shortcode='lo' WHERE code='lao';
UPDATE IsoLanguages SET shortcode='la' WHERE code='lat';
UPDATE IsoLanguages SET shortcode='lv' WHERE code='lav';
UPDATE IsoLanguages SET shortcode='li' WHERE code='lim';
UPDATE IsoLanguages SET shortcode='ln' WHERE code='lin';
UPDATE IsoLanguages SET shortcode='lt' WHERE code='lit';
UPDATE IsoLanguages SET shortcode='lb' WHERE code='ltz';
UPDATE IsoLanguages SET shortcode='lu' WHERE code='lub';
UPDATE IsoLanguages SET shortcode='lg' WHERE code='lug';
UPDATE IsoLanguages SET shortcode='mk' WHERE code='mac';
UPDATE IsoLanguages SET shortcode='mh' WHERE code='mah';
UPDATE IsoLanguages SET shortcode='ml' WHERE code='mal';
UPDATE IsoLanguages SET shortcode='mi' WHERE code='mao';
UPDATE IsoLanguages SET shortcode='mr' WHERE code='mar';
UPDATE IsoLanguages SET shortcode='ms' WHERE code='may';
UPDATE IsoLanguages SET shortcode='mg' WHERE code='mlg';
UPDATE IsoLanguages SET shortcode='mt' WHERE code='mlt';
UPDATE IsoLanguages SET shortcode='ml' WHERE code='mol';
UPDATE IsoLanguages SET shortcode='mn' WHERE code='mon';
UPDATE IsoLanguages SET shortcode='na' WHERE code='nau';
UPDATE IsoLanguages SET shortcode='nv' WHERE code='nav';
UPDATE IsoLanguages SET shortcode='nr' WHERE code='nbl';
UPDATE IsoLanguages SET shortcode='nd' WHERE code='nde';
UPDATE IsoLanguages SET shortcode='ng' WHERE code='ndo';
UPDATE IsoLanguages SET shortcode='ne' WHERE code='nep';
UPDATE IsoLanguages SET shortcode='nn' WHERE code='nno';
UPDATE IsoLanguages SET shortcode='nb' WHERE code='nob';
UPDATE IsoLanguages SET shortcode='no' WHERE code='nor';
UPDATE IsoLanguages SET shortcode='ny' WHERE code='nya';
UPDATE IsoLanguages SET shortcode='oc' WHERE code='oci';
UPDATE IsoLanguages SET shortcode='oj' WHERE code='oji';
UPDATE IsoLanguages SET shortcode='or' WHERE code='ori';
UPDATE IsoLanguages SET shortcode='om' WHERE code='orm';
UPDATE IsoLanguages SET shortcode='os' WHERE code='oss';
UPDATE IsoLanguages SET shortcode='pa' WHERE code='pan';
UPDATE IsoLanguages SET shortcode='fa' WHERE code='per';
UPDATE IsoLanguages SET shortcode='pi' WHERE code='pli';
UPDATE IsoLanguages SET shortcode='pl' WHERE code='pol';
UPDATE IsoLanguages SET shortcode='pt' WHERE code='por';
UPDATE IsoLanguages SET shortcode='ps' WHERE code='pus';
UPDATE IsoLanguages SET shortcode='qu' WHERE code='que';
UPDATE IsoLanguages SET shortcode='rm' WHERE code='roh';
UPDATE IsoLanguages SET shortcode='ro' WHERE code='rum';
UPDATE IsoLanguages SET shortcode='rn' WHERE code='run';
UPDATE IsoLanguages SET shortcode='ru' WHERE code='rus';
UPDATE IsoLanguages SET shortcode='sg' WHERE code='sag';
UPDATE IsoLanguages SET shortcode='sa' WHERE code='san';
UPDATE IsoLanguages SET shortcode='sr' WHERE code='srp';
UPDATE IsoLanguages SET shortcode='hr' WHERE code='hrv';
UPDATE IsoLanguages SET shortcode='si' WHERE code='sin';
UPDATE IsoLanguages SET shortcode='sk' WHERE code='slo';
UPDATE IsoLanguages SET shortcode='sl' WHERE code='slv';
UPDATE IsoLanguages SET shortcode='se' WHERE code='sme';
UPDATE IsoLanguages SET shortcode='sm' WHERE code='smo';
UPDATE IsoLanguages SET shortcode='sn' WHERE code='sna';
UPDATE IsoLanguages SET shortcode='sd' WHERE code='snd';
UPDATE IsoLanguages SET shortcode='so' WHERE code='som';
UPDATE IsoLanguages SET shortcode='st' WHERE code='sot';
UPDATE IsoLanguages SET shortcode='es' WHERE code='spa';
UPDATE IsoLanguages SET shortcode='sc' WHERE code='srd';
UPDATE IsoLanguages SET shortcode='ss' WHERE code='ssw';
UPDATE IsoLanguages SET shortcode='su' WHERE code='sun';
UPDATE IsoLanguages SET shortcode='sw' WHERE code='swa';
UPDATE IsoLanguages SET shortcode='sv' WHERE code='swe';
UPDATE IsoLanguages SET shortcode='ty' WHERE code='tah';
UPDATE IsoLanguages SET shortcode='ta' WHERE code='tam';
UPDATE IsoLanguages SET shortcode='tt' WHERE code='tat';
UPDATE IsoLanguages SET shortcode='te' WHERE code='tel';
UPDATE IsoLanguages SET shortcode='tg' WHERE code='tgk';
UPDATE IsoLanguages SET shortcode='tl' WHERE code='tgl';
UPDATE IsoLanguages SET shortcode='th' WHERE code='tha';
UPDATE IsoLanguages SET shortcode='bo' WHERE code='tib';
UPDATE IsoLanguages SET shortcode='ti' WHERE code='tir';
UPDATE IsoLanguages SET shortcode='to' WHERE code='ton';
UPDATE IsoLanguages SET shortcode='tn' WHERE code='tsn';
UPDATE IsoLanguages SET shortcode='ts' WHERE code='tso';
UPDATE IsoLanguages SET shortcode='tk' WHERE code='tuk';
UPDATE IsoLanguages SET shortcode='tr' WHERE code='tur';
UPDATE IsoLanguages SET shortcode='tw' WHERE code='twi';
UPDATE IsoLanguages SET shortcode='ug' WHERE code='uig';
UPDATE IsoLanguages SET shortcode='uk' WHERE code='ukr';
UPDATE IsoLanguages SET shortcode='ur' WHERE code='urd';
UPDATE IsoLanguages SET shortcode='uz' WHERE code='uzb';
UPDATE IsoLanguages SET shortcode='ve' WHERE code='ven';
UPDATE IsoLanguages SET shortcode='vi' WHERE code='vie';
UPDATE IsoLanguages SET shortcode='vo' WHERE code='vol';
UPDATE IsoLanguages SET shortcode='cy' WHERE code='wel';
UPDATE IsoLanguages SET shortcode='wa' WHERE code='wln';
UPDATE IsoLanguages SET shortcode='wo' WHERE code='wol';
UPDATE IsoLanguages SET shortcode='xh' WHERE code='xho';
UPDATE IsoLanguages SET shortcode='yi' WHERE code='yid';
UPDATE IsoLanguages SET shortcode='yo' WHERE code='yor';
UPDATE IsoLanguages SET shortcode='za' WHERE code='zha';
UPDATE IsoLanguages SET shortcode='zu' WHERE code='zul';

INSERT INTO Categories VALUES (111,'z3950Servers');
INSERT INTO Categories VALUES (112,'registers');
INSERT INTO Categories VALUES (113,'physicalSamples');

-- INSERT INTO Settings VALUES (722,720,'enableSearchPanel','false');
-- INSERT INTO Settings VALUES (900,1,'harvester',NULL);
-- INSERT INTO Settings VALUES (901,900,'enableEditing','false');

update settings set value='true' where name in ('enable', 'sorted') and id in (951, 954);
update settings set value='false' where name = 'ignored' and id=955;

UPDATE settings SET value='0 0 0/2 * * ?' where name = 'every';

UPDATE Settings SET value='2.8.0' WHERE name='version';
UPDATE Settings SET value='0' WHERE name='subVersion';
