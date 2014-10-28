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
-- Name: settings; Type: TABLE; Schema: public; Owner: jetty; Tablespace: 
--

TRUNCATE settings;

--
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: jetty
--

COPY settings (id, parentid, name, value) FROM stdin;
0	\N	root	\N
1	0	system	\N
2	0	harvesting	\N
10	1	site	\N
11	10	name	My GeoNetwork catalogue
13	10	organization	My organization
14	1	platform	\N
15	14	version	2.10.3
16	14	subVersion	0
20	1	server	\N
21	20	host	localhost
22	20	port	8080
23	20	protocol	http
24	20	securePort	8443
30	1	intranet	\N
31	30	network	127.0.0.1
32	30	netmask	255.0.0.0
40	1	z3950	\N
41	40	enable	true
42	40	port	2100
50	1	proxy	\N
51	50	use	false
52	50	host	\N
53	50	port	\N
54	50	username	\N
55	50	password	\N
60	1	feedback	\N
61	60	email	\N
62	60	mailServer	\N
63	62	host	\N
64	62	port	25
70	1	removedMetadata	\N
71	70	dir	WEB-INF/data/removed
90	1	selectionmanager	\N
91	90	maxrecords	1000
120	1	csw	\N
121	120	enable	true
122	120	contactId	\N
131	120	metadataPublic	false
170	1	shib	\N
171	170	use	false
172	170	path	/geonetwork/srv/en/shib.user.login
173	170	attrib	\N
174	173	username	REMOTE_USER
175	173	surname	Shib-Person-surname
176	173	firstname	Shib-InetOrgPerson-givenName
177	173	profile	Shib-EP-Entitlement
178	173	group	\N
179	170	defaultGroup	\N
180	173	organizationName	\N
181	173	postalAddress	\N
182	173	phone	\N
183	173	email	\N
184	173	fullName	\N
190	1	userSelfRegistration	\N
191	190	enable	false
200	1	clickablehyperlinks	\N
201	200	enable	true
210	1	localrating	\N
211	210	enable	false
220	1	downloadservice	\N
221	220	leave	false
222	220	simple	true
223	220	withdisclaimer	false
230	1	xlinkResolver	\N
231	230	enable	false
240	1	autofixing	\N
241	240	enable	true
250	1	searchStats	\N
251	250	enable	false
600	1	indexoptimizer	\N
601	600	enable	true
602	600	at	\N
603	602	hour	0
604	602	min	0
605	602	sec	0
606	600	interval	\N
607	606	day	0
608	606	hour	24
609	606	min	0
700	1	oai	\N
701	700	mdmode	1
702	700	tokentimeout	3600
703	700	cachesize	60
720	1	inspire	\N
721	720	enable	false
722	720	enableSearchPanel	false
723	720	atom	remote
724	720	atomSchedule	0 0 0/24 ? * *
725	720	atomProtocol	INSPIRE-ATOM
900	1	harvester	\N
901	900	enableEditing	false
910	1	metadata	\N
911	910	enableSimpleView	true
912	910	enableIsoView	true
913	910	enableInspireView	false
914	910	enableXmlView	true
915	910	defaultView	simple
917	1	metadataprivs	\N
918	917	usergrouponly	false
920	1	threadedindexing	\N
921	920	maxthreads	1
950	1	autodetect	\N
951	950	enable	false
952	1	requestedLanguage	\N
953	952	only	prefer_locale
954	952	sorted	false
956	1	hidewithheldelements	\N
957	956	enable	false
958	956	keepMarkedElement	true
12	10	siteId	00a5c6b8-d729-4629-a82d-8a7b3317d2c2
17	10	svnUuid	f216a195-652a-4131-b34e-52f2f95776a8
\.



