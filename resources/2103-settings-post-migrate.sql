--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
TRUNCATE settings;

--
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: geonetwork
--

COPY settings (id, parentid, name, value) FROM stdin;
0	\N	root	\N
1	0	system	\N
2	0	harvesting	\N
10	1	site	\N
14	1	platform	\N
15	14	version	2.10.3
16	14	subVersion	0
20	1	server	\N
30	1	intranet	\N
40	1	z3950	\N
50	1	proxy	\N
60	1	feedback	\N
62	60	mailServer	\N
70	1	removedMetadata	\N
90	1	selectionmanager	\N
120	1	csw	\N
170	1	shib	\N
173	170	attrib	\N
180	173	organizationName	\N
181	173	postalAddress	\N
182	173	phone	\N
183	173	email	\N
184	173	fullName	\N
190	1	userSelfRegistration	\N
200	1	clickablehyperlinks	\N
210	1	localrating	\N
220	1	downloadservice	\N
230	1	xlinkResolver	\N
240	1	autofixing	\N
250	1	searchStats	\N
600	1	indexoptimizer	\N
602	600	at	\N
606	600	interval	\N
700	1	oai	\N
720	1	inspire	\N
900	1	harvester	\N
910	1	metadata	\N
917	1	metadataprivs	\N
920	1	threadedindexing	\N
950	1	autodetect	\N
952	1	requestedLanguage	\N
956	1	hidewithheldelements	\N
17	10	svnUuid	f216a195-652a-4131-b34e-52f2f95776a8
231	230	enable	false
171	170	use	false
607	606	day	0
223	220	withdisclaimer	false
241	240	enable	true
951	950	enable	false
918	917	usergrouponly	false
12	10	siteId	00a5c6b8-d729-4629-a82d-8a7b3317d2c2
178	173	group	
608	606	hour	24
191	190	enable	false
63	62	host	
913	910	enableInspireView	true
912	910	enableIsoView	true
41	40	enable	true
31	30	network	127.0.0.1
957	956	enable	false
91	90	maxrecords	1000
251	250	enable	false
24	20	securePort	8443
703	700	cachesize	60
222	220	simple	true
723	720	atom	remote
176	173	firstname	Shib-InetOrgPerson-givenName
42	40	port	2100
211	210	enable	false
23	20	protocol	http
702	700	tokentimeout	3600
52	50	host	
177	173	profile	Shib-EP-Entitlement
32	30	netmask	255.0.0.0
221	220	leave	false
22	20	port	8080
721	720	enable	true
51	50	use	false
13	10	organization	My organization
953	952	only	prefer_locale
914	910	enableXmlView	true
609	606	min	0
71	70	dir	WEB-INF/data/removed
179	170	defaultGroup	
605	602	sec	0
722	720	enableSearchPanel	true
61	60	email	
701	700	mdmode	1
601	600	enable	true
911	910	enableSimpleView	true
175	173	surname	Shib-Person-surname
724	720	atomSchedule	0 0 0/24 ? * *
604	602	min	0
172	170	path	/geonetwork/srv/en/shib.user.login
603	602	hour	0
901	900	enableEditing	false
11	10	name	My GeoNetwork catalogue
915	910	defaultView	inspire
53	50	port	
958	956	keepMarkedElement	true
21	20	host	localhost
54	50	username	
55	50	password	
725	720	atomProtocol	INSPIRE-ATOM
954	952	sorted	false
64	62	port	25
921	920	maxthreads	1
201	200	enable	true
174	173	username	REMOTE_USER
121	120	enable	true
131	120	metadataPublic	false
122	120	contactId	54
\.


