--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: words; Type: TABLE DATA; Schema: public; Owner: arkadefr
--

COPY words (id, language, word, keywords, definition, difficulty) FROM stdin;
1	EN	slogging                                                                                                                        	\N	trimmer, travailler dur	\N
2	EN	transfixed                                                                                                                      	\N	subjugué, captivé	\N
3	EN	allowance                                                                                                                       	\N	argent de poche	\N
4	EN	womb                                                                                                                            	\N	uterus, ventre	\N
5	EN	fraught                                                                                                                         	\N	stressant, tendu	\N
6	EN	averse                                                                                                                          	\N	éprouver de la répugnance pour	\N
7	EN	delineate                                                                                                                       	\N	définir	\N
8	EN	nudge                                                                                                                           	\N	petit coup de coude	\N
9	EN	shire                                                                                                                           	\N	comté	\N
10	EN	edible                                                                                                                          	\N	mangeable, comestible	\N
11	EN	dart                                                                                                                            	\N	foncer, se précipiter	\N
12	EN	swerve                                                                                                                          	\N	faire un écart	\N
13	EN	net                                                                                                                             	\N	filet	\N
14	EN	distress                                                                                                                        	\N	bouleverser	\N
15	EN	crackle                                                                                                                         	\N	crépiter	\N
16	EN	stiff                                                                                                                           	\N	rigide	\N
17	EN	incur                                                                                                                           	\N	encourir	\N
18	EN	trite                                                                                                                           	\N	banal	\N
19	EN	wrestle                                                                                                                         	\N	luter	\N
20	EN	apathetic                                                                                                                       	\N	apathique, indifférent	\N
21	EN	casualty                                                                                                                        	\N	blessé, mort	\N
22	EN	clameur                                                                                                                         	\N	réclamer	\N
23	EN	ubiquitous                                                                                                                      	\N	omniprésent	\N
24	EN	eschew                                                                                                                          	\N	éviter, fuir	\N
25	EN	prying                                                                                                                          	\N	indiscret	\N
26	EN	fringe                                                                                                                          	\N	banlieue, marge	\N
27	EN	grasp                                                                                                                           	\N	saisir, comprendre	\N
28	EN	dismay                                                                                                                          	\N	désarroi, consterner	\N
29	EN	fiddly                                                                                                                          	\N	minutieux, délicat	\N
30	EN	thrust                                                                                                                          	\N	pousser, forcer, imposer	\N
31	EN	wand                                                                                                                            	\N	baguette magique	\N
32	EN	twitch                                                                                                                          	\N	avoir un mouvement convulsif	\N
33	EN	brass                                                                                                                           	\N	cuivre	\N
34	EN	quibble                                                                                                                         	\N	critique	\N
35	EN	cog                                                                                                                             	\N	roue dentée	\N
36	EN	daunting                                                                                                                        	\N	intimidant	\N
37	EN	slogging                                                                                                                        	\N	trimmer, travailler dur	\N
38	EN	quagmire                                                                                                                        	\N	bourbier	\N
39	EN	cogent                                                                                                                          	\N	convaincant / preuve	\N
\.


SET search_path = sqitch, pg_catalog;

--
-- Data for Name: projects; Type: TABLE DATA; Schema: sqitch; Owner: arkadefr
--

COPY projects (project, uri, created_at, creator_name, creator_email) FROM stdin;
words	\N	2018-02-05 17:09:34.468959-05	aRkadeFR	contact@arkade.info
\.


--
-- Data for Name: changes; Type: TABLE DATA; Schema: sqitch; Owner: arkadefr
--

COPY changes (change_id, script_hash, change, project, note, committed_at, committer_name, committer_email, planned_at, planner_name, planner_email) FROM stdin;
2a1d4c93c2f27b05502138d9f32d75c0e9b354e5	a3ca206e036b832ea2b564aa3010056004afcb8d	0001-words	words	Schema for words	2018-02-05 17:09:48.806478-05	aRkadeFR	contact@arkade.info	2018-02-05 16:59:14-05	aRkadeFR	contact@arkade.info
\.


--
-- Data for Name: dependencies; Type: TABLE DATA; Schema: sqitch; Owner: arkadefr
--

COPY dependencies (change_id, type, dependency, dependency_id) FROM stdin;
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: sqitch; Owner: arkadefr
--

COPY events (event, change_id, change, project, note, requires, conflicts, tags, committed_at, committer_name, committer_email, planned_at, planner_name, planner_email) FROM stdin;
deploy	2a1d4c93c2f27b05502138d9f32d75c0e9b354e5	0001-words	words	Schema for words	{}	{}	{}	2018-02-05 17:09:34.577274-05	aRkadeFR	contact@arkade.info	2018-02-05 16:59:14-05	aRkadeFR	contact@arkade.info
revert	2a1d4c93c2f27b05502138d9f32d75c0e9b354e5	0001-words	words	Schema for words	{}	{}	{}	2018-02-05 17:09:41.109546-05	aRkadeFR	contact@arkade.info	2018-02-05 16:59:14-05	aRkadeFR	contact@arkade.info
deploy	2a1d4c93c2f27b05502138d9f32d75c0e9b354e5	0001-words	words	Schema for words	{}	{}	{}	2018-02-05 17:09:48.807546-05	aRkadeFR	contact@arkade.info	2018-02-05 16:59:14-05	aRkadeFR	contact@arkade.info
\.


--
-- Data for Name: releases; Type: TABLE DATA; Schema: sqitch; Owner: arkadefr
--

COPY releases (version, installed_at, installer_name, installer_email) FROM stdin;
1.10000002	2018-02-05 17:09:34.466124-05	aRkadeFR	contact@arkade.info
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: sqitch; Owner: arkadefr
--

COPY tags (tag_id, tag, project, change_id, note, committed_at, committer_name, committer_email, planned_at, planner_name, planner_email) FROM stdin;
\.


SET search_path = public, pg_catalog;

--
-- Name: words_id_seq; Type: SEQUENCE SET; Schema: public; Owner: arkadefr
--

SELECT pg_catalog.setval('words_id_seq', 39, true);


--
-- PostgreSQL database dump complete
--

