--
-- PostgreSQL database dump
--

-- Dumped from database version 10.3 (Debian 10.3-1.pgdg90+1)
-- Dumped by pg_dump version 10.3 (Debian 10.3-1.pgdg90+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: sqitch; Type: SCHEMA; Schema: -; Owner: arkadefr
--

CREATE SCHEMA sqitch;


ALTER SCHEMA sqitch OWNER TO arkadefr;

--
-- Name: SCHEMA sqitch; Type: COMMENT; Schema: -; Owner: arkadefr
--

COMMENT ON SCHEMA sqitch IS 'Sqitch database deployment metadata v1.0.';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: user_hash_password(); Type: FUNCTION; Schema: public; Owner: arkadefr
--

CREATE FUNCTION public.user_hash_password() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.passpass := crypt(NEW.passpass, gen_salt('bf', 8));
  RETURN NEW;
END
$$;


ALTER FUNCTION public.user_hash_password() OWNER TO arkadefr;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: users; Type: TABLE; Schema: public; Owner: arkadefr
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username text NOT NULL,
    passpass text NOT NULL
);


ALTER TABLE public.users OWNER TO arkadefr;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: arkadefr
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO arkadefr;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: arkadefr
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: words; Type: TABLE; Schema: public; Owner: arkadefr
--

CREATE TABLE public.words (
    id bigint NOT NULL,
    language character(2) NOT NULL,
    word character varying(128) NOT NULL,
    keywords text[],
    definition text NOT NULL,
    difficulty integer,
    userid bigint NOT NULL,
    inserted_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.words OWNER TO arkadefr;

--
-- Name: words_id_seq; Type: SEQUENCE; Schema: public; Owner: arkadefr
--

CREATE SEQUENCE public.words_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.words_id_seq OWNER TO arkadefr;

--
-- Name: words_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: arkadefr
--

ALTER SEQUENCE public.words_id_seq OWNED BY public.words.id;


--
-- Name: changes; Type: TABLE; Schema: sqitch; Owner: arkadefr
--

CREATE TABLE sqitch.changes (
    change_id text NOT NULL,
    script_hash text,
    change text NOT NULL,
    project text NOT NULL,
    note text DEFAULT ''::text NOT NULL,
    committed_at timestamp with time zone DEFAULT clock_timestamp() NOT NULL,
    committer_name text NOT NULL,
    committer_email text NOT NULL,
    planned_at timestamp with time zone NOT NULL,
    planner_name text NOT NULL,
    planner_email text NOT NULL
);


ALTER TABLE sqitch.changes OWNER TO arkadefr;

--
-- Name: TABLE changes; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON TABLE sqitch.changes IS 'Tracks the changes currently deployed to the database.';


--
-- Name: COLUMN changes.change_id; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.changes.change_id IS 'Change primary key.';


--
-- Name: COLUMN changes.script_hash; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.changes.script_hash IS 'Deploy script SHA-1 hash.';


--
-- Name: COLUMN changes.change; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.changes.change IS 'Name of a deployed change.';


--
-- Name: COLUMN changes.project; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.changes.project IS 'Name of the Sqitch project to which the change belongs.';


--
-- Name: COLUMN changes.note; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.changes.note IS 'Description of the change.';


--
-- Name: COLUMN changes.committed_at; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.changes.committed_at IS 'Date the change was deployed.';


--
-- Name: COLUMN changes.committer_name; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.changes.committer_name IS 'Name of the user who deployed the change.';


--
-- Name: COLUMN changes.committer_email; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.changes.committer_email IS 'Email address of the user who deployed the change.';


--
-- Name: COLUMN changes.planned_at; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.changes.planned_at IS 'Date the change was added to the plan.';


--
-- Name: COLUMN changes.planner_name; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.changes.planner_name IS 'Name of the user who planed the change.';


--
-- Name: COLUMN changes.planner_email; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.changes.planner_email IS 'Email address of the user who planned the change.';


--
-- Name: dependencies; Type: TABLE; Schema: sqitch; Owner: arkadefr
--

CREATE TABLE sqitch.dependencies (
    change_id text NOT NULL,
    type text NOT NULL,
    dependency text NOT NULL,
    dependency_id text,
    CONSTRAINT dependencies_check CHECK ((((type = 'require'::text) AND (dependency_id IS NOT NULL)) OR ((type = 'conflict'::text) AND (dependency_id IS NULL))))
);


ALTER TABLE sqitch.dependencies OWNER TO arkadefr;

--
-- Name: TABLE dependencies; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON TABLE sqitch.dependencies IS 'Tracks the currently satisfied dependencies.';


--
-- Name: COLUMN dependencies.change_id; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.dependencies.change_id IS 'ID of the depending change.';


--
-- Name: COLUMN dependencies.type; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.dependencies.type IS 'Type of dependency.';


--
-- Name: COLUMN dependencies.dependency; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.dependencies.dependency IS 'Dependency name.';


--
-- Name: COLUMN dependencies.dependency_id; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.dependencies.dependency_id IS 'Change ID the dependency resolves to.';


--
-- Name: events; Type: TABLE; Schema: sqitch; Owner: arkadefr
--

CREATE TABLE sqitch.events (
    event text NOT NULL,
    change_id text NOT NULL,
    change text NOT NULL,
    project text NOT NULL,
    note text DEFAULT ''::text NOT NULL,
    requires text[] DEFAULT '{}'::text[] NOT NULL,
    conflicts text[] DEFAULT '{}'::text[] NOT NULL,
    tags text[] DEFAULT '{}'::text[] NOT NULL,
    committed_at timestamp with time zone DEFAULT clock_timestamp() NOT NULL,
    committer_name text NOT NULL,
    committer_email text NOT NULL,
    planned_at timestamp with time zone NOT NULL,
    planner_name text NOT NULL,
    planner_email text NOT NULL,
    CONSTRAINT events_event_check CHECK ((event = ANY (ARRAY['deploy'::text, 'revert'::text, 'fail'::text, 'merge'::text])))
);


ALTER TABLE sqitch.events OWNER TO arkadefr;

--
-- Name: TABLE events; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON TABLE sqitch.events IS 'Contains full history of all deployment events.';


--
-- Name: COLUMN events.event; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.events.event IS 'Type of event.';


--
-- Name: COLUMN events.change_id; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.events.change_id IS 'Change ID.';


--
-- Name: COLUMN events.change; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.events.change IS 'Change name.';


--
-- Name: COLUMN events.project; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.events.project IS 'Name of the Sqitch project to which the change belongs.';


--
-- Name: COLUMN events.note; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.events.note IS 'Description of the change.';


--
-- Name: COLUMN events.requires; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.events.requires IS 'Array of the names of required changes.';


--
-- Name: COLUMN events.conflicts; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.events.conflicts IS 'Array of the names of conflicting changes.';


--
-- Name: COLUMN events.tags; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.events.tags IS 'Tags associated with the change.';


--
-- Name: COLUMN events.committed_at; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.events.committed_at IS 'Date the event was committed.';


--
-- Name: COLUMN events.committer_name; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.events.committer_name IS 'Name of the user who committed the event.';


--
-- Name: COLUMN events.committer_email; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.events.committer_email IS 'Email address of the user who committed the event.';


--
-- Name: COLUMN events.planned_at; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.events.planned_at IS 'Date the event was added to the plan.';


--
-- Name: COLUMN events.planner_name; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.events.planner_name IS 'Name of the user who planed the change.';


--
-- Name: COLUMN events.planner_email; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.events.planner_email IS 'Email address of the user who plan planned the change.';


--
-- Name: projects; Type: TABLE; Schema: sqitch; Owner: arkadefr
--

CREATE TABLE sqitch.projects (
    project text NOT NULL,
    uri text,
    created_at timestamp with time zone DEFAULT clock_timestamp() NOT NULL,
    creator_name text NOT NULL,
    creator_email text NOT NULL
);


ALTER TABLE sqitch.projects OWNER TO arkadefr;

--
-- Name: TABLE projects; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON TABLE sqitch.projects IS 'Sqitch projects deployed to this database.';


--
-- Name: COLUMN projects.project; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.projects.project IS 'Unique Name of a project.';


--
-- Name: COLUMN projects.uri; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.projects.uri IS 'Optional project URI';


--
-- Name: COLUMN projects.created_at; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.projects.created_at IS 'Date the project was added to the database.';


--
-- Name: COLUMN projects.creator_name; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.projects.creator_name IS 'Name of the user who added the project.';


--
-- Name: COLUMN projects.creator_email; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.projects.creator_email IS 'Email address of the user who added the project.';


--
-- Name: releases; Type: TABLE; Schema: sqitch; Owner: arkadefr
--

CREATE TABLE sqitch.releases (
    version real NOT NULL,
    installed_at timestamp with time zone DEFAULT clock_timestamp() NOT NULL,
    installer_name text NOT NULL,
    installer_email text NOT NULL
);


ALTER TABLE sqitch.releases OWNER TO arkadefr;

--
-- Name: TABLE releases; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON TABLE sqitch.releases IS 'Sqitch registry releases.';


--
-- Name: COLUMN releases.version; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.releases.version IS 'Version of the Sqitch registry.';


--
-- Name: COLUMN releases.installed_at; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.releases.installed_at IS 'Date the registry release was installed.';


--
-- Name: COLUMN releases.installer_name; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.releases.installer_name IS 'Name of the user who installed the registry release.';


--
-- Name: COLUMN releases.installer_email; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.releases.installer_email IS 'Email address of the user who installed the registry release.';


--
-- Name: tags; Type: TABLE; Schema: sqitch; Owner: arkadefr
--

CREATE TABLE sqitch.tags (
    tag_id text NOT NULL,
    tag text NOT NULL,
    project text NOT NULL,
    change_id text NOT NULL,
    note text DEFAULT ''::text NOT NULL,
    committed_at timestamp with time zone DEFAULT clock_timestamp() NOT NULL,
    committer_name text NOT NULL,
    committer_email text NOT NULL,
    planned_at timestamp with time zone NOT NULL,
    planner_name text NOT NULL,
    planner_email text NOT NULL
);


ALTER TABLE sqitch.tags OWNER TO arkadefr;

--
-- Name: TABLE tags; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON TABLE sqitch.tags IS 'Tracks the tags currently applied to the database.';


--
-- Name: COLUMN tags.tag_id; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.tags.tag_id IS 'Tag primary key.';


--
-- Name: COLUMN tags.tag; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.tags.tag IS 'Project-unique tag name.';


--
-- Name: COLUMN tags.project; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.tags.project IS 'Name of the Sqitch project to which the tag belongs.';


--
-- Name: COLUMN tags.change_id; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.tags.change_id IS 'ID of last change deployed before the tag was applied.';


--
-- Name: COLUMN tags.note; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.tags.note IS 'Description of the tag.';


--
-- Name: COLUMN tags.committed_at; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.tags.committed_at IS 'Date the tag was applied to the database.';


--
-- Name: COLUMN tags.committer_name; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.tags.committer_name IS 'Name of the user who applied the tag.';


--
-- Name: COLUMN tags.committer_email; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.tags.committer_email IS 'Email address of the user who applied the tag.';


--
-- Name: COLUMN tags.planned_at; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.tags.planned_at IS 'Date the tag was added to the plan.';


--
-- Name: COLUMN tags.planner_name; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.tags.planner_name IS 'Name of the user who planed the tag.';


--
-- Name: COLUMN tags.planner_email; Type: COMMENT; Schema: sqitch; Owner: arkadefr
--

COMMENT ON COLUMN sqitch.tags.planner_email IS 'Email address of the user who planned the tag.';


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: arkadefr
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: words id; Type: DEFAULT; Schema: public; Owner: arkadefr
--

ALTER TABLE ONLY public.words ALTER COLUMN id SET DEFAULT nextval('public.words_id_seq'::regclass);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: arkadefr
--

COPY public.users (id, username, passpass) FROM stdin;
2	wiktoria	$2a$08$RtYXZmoDLdVupCgu7GCXluJWlTyq5/zhot7chK.QPR56FvTCqlwPS
1	flog	$2a$08$dVQtmGG1Tg54EHkCyZCqOu1eKRgtcq0SYxLQvkDqIrxU.M1BwA33q
\.


--
-- Data for Name: words; Type: TABLE DATA; Schema: public; Owner: arkadefr
--

COPY public.words (id, language, word, keywords, definition, difficulty, userid, inserted_at) FROM stdin;
315	EN	limp	\N	mou, molle	\N	1	2018-07-22 12:55:15.050953+02
400	EN	to crib	\N	copier, pomper	\N	1	2018-07-29 14:55:15.050953+02
399	EN	crib	\N	berceau	\N	1	2018-07-29 12:55:15.050953+02
398	EN	as it ought to be	\N	ce qu'il devrait etre	\N	1	2018-07-29 10:55:15.050953+02
397	EN	to chime	\N	sonner (les cloches)	\N	1	2018-07-29 08:55:15.050953+02
396	EN	chime	\N	carillon	\N	1	2018-07-29 06:55:15.050953+02
395	EN	to deem	\N	juger, estimer, considerer	\N	1	2018-07-29 04:55:15.050953+02
394	EN	comprise (sth)	\N	constituer, representer, former	\N	1	2018-07-29 02:55:15.050953+02
393	EN	reluctantly	\N	a contre-coeur, avec reticence	\N	1	2018-07-29 00:55:15.050953+02
392	EN	liability	\N	handicap, frein, boulet	\N	1	2018-07-28 22:55:15.050953+02
391	EN	snappy	\N	vif, energique	\N	1	2018-07-28 20:55:15.050953+02
390	EN	demeaning	\N	degrandant, devalorisant	\N	1	2018-07-28 18:55:15.050953+02
389	EN	save, save for	\N	sauf	\N	1	2018-07-28 16:55:15.050953+02
388	EN	to utter (sth)	\N	prononcer, dire, pousser, proferer	\N	1	2018-07-28 14:55:15.050953+02
387	EN	rung	\N	barreau, echelon	\N	1	2018-07-28 12:55:15.050953+02
386	EN	to loll	\N	se prelasser, faineanter, pendre, tomber	\N	1	2018-07-28 10:55:15.050953+02
385	EN	to conceal (sth)	\N	dissimuler, cacher	\N	1	2018-07-28 08:55:15.050953+02
384	EN	dreary	\N	morne, gris	\N	1	2018-07-28 06:55:15.050953+02
383	EN	whispered to do (sth)	\N	il se murmure que..., on dit que...	\N	1	2018-07-28 04:55:15.050953+02
381	EN	enamored of (sth)	\N	passionne de	\N	1	2018-07-28 00:55:15.050953+02
380	EN	worn	\N	use, erode	\N	1	2018-07-27 22:55:15.050953+02
378	EN	uncanny	\N	mysterieux, etrange	\N	1	2018-07-27 18:55:15.050953+02
377	EN	furnace	\N	fourneau, chaudiere, fournaise	\N	1	2018-07-27 16:55:15.050953+02
376	EN	to botch	\N	foirer, rater, bacler	\N	1	2018-07-27 14:55:15.050953+02
375	EN	to bulge	\N	se gonfler, ressortir, bomber	\N	1	2018-07-27 12:55:15.050953+02
374	EN	drawl	\N	voix trainante	\N	1	2018-07-27 10:55:15.050953+02
373	EN	damp	\N	humide	\N	1	2018-07-27 08:55:15.050953+02
372	EN	feeble	\N	faible, febrile	\N	1	2018-07-27 06:55:15.050953+02
371	EN	to grate (sth)	\N	raper	\N	1	2018-07-27 04:55:15.050953+02
370	EN	to grate	\N	grincer, crisser	\N	1	2018-07-27 02:55:15.050953+02
369	EN	to loathe (sb/sth)	\N	detester, hair, execrer	\N	1	2018-07-27 00:55:15.050953+02
368	EN	shingle	\N	galets, graviers	\N	1	2018-07-26 22:55:15.050953+02
367	EN	to astound (sb)	\N	stupefier, etonner	\N	1	2018-07-26 20:55:15.050953+02
366	EN	unkempt	\N	neglige, peu soigne	\N	1	2018-07-26 18:55:15.050953+02
365	EN	frieze	\N	frise	\N	1	2018-07-26 16:55:15.050953+02
364	EN	to flaunt	\N	exhiber, montrer, etaler	\N	1	2018-07-26 14:55:15.050953+02
363	EN	to startle (sb/sth)	\N	surprendre, etonner, faire sursauter	\N	1	2018-07-26 12:55:15.050953+02
362	EN	to aspire to (sth)	\N	aspirer a	\N	1	2018-07-26 10:55:15.050953+02
361	EN	seldom	\N	rarement	\N	1	2018-07-26 08:55:15.050953+02
360	EN	blotch	\N	tache	\N	1	2018-07-26 06:55:15.050953+02
359	EN	streak	\N	trace, marque, trainee	\N	1	2018-07-26 04:55:15.050953+02
358	EN	to boast	\N	se vanter, fanfaronner	\N	1	2018-07-26 02:55:15.050953+02
357	EN	to smear	\N	etaler, mettre	\N	1	2018-07-26 00:55:15.050953+02
356	EN	smear	\N	tache, trace	\N	1	2018-07-25 22:55:15.050953+02
354	EN	to flare	\N	eclater, s'echauffer	\N	1	2018-07-25 18:55:15.050953+02
353	EN	tenement	\N	immeuble	\N	1	2018-07-25 16:55:15.050953+02
352	EN	grim	\N	sombre	\N	1	2018-07-25 14:55:15.050953+02
351	EN	to bow to (sb)	\N	faire une reverence, s'incliner	\N	1	2018-07-25 12:55:15.050953+02
350	EN	lint	\N	peluche, charpie	\N	1	2018-07-25 10:55:15.050953+02
349	EN	to jot (sth) on (sth)	\N	noter (qqchse) sur (qqchse)	\N	1	2018-07-25 08:55:15.050953+02
348	EN	a jot of (sth)	\N	un brin de, un iota de	\N	1	2018-07-25 06:55:15.050953+02
347	EN	realtor	\N	agent immobilier	\N	1	2018-07-25 04:55:15.050953+02
346	EN	blatant	\N	flagrant	\N	1	2018-07-25 02:55:15.050953+02
345	EN	to smudge	\N	tacher, etaler	\N	1	2018-07-25 00:55:15.050953+02
344	EN	smudge	\N	tache, bavure	\N	1	2018-07-24 22:55:15.050953+02
343	EN	to quail	\N	trembler, tressaillir	\N	1	2018-07-24 20:55:15.050953+02
342	EN	to sag	\N	s'affaisser, tomber, pendre	\N	1	2018-07-24 18:55:15.050953+02
341	EN	swarm	\N	essaim, colonie, masse	\N	1	2018-07-24 16:55:15.050953+02
340	EN	to splinter	\N	se briser en eclat	\N	1	2018-07-24 14:55:15.050953+02
339	EN	splinter	\N	echarde, esquille	\N	1	2018-07-24 12:55:15.050953+02
338	EN	rustle	\N	bruissement, froissement	\N	1	2018-07-24 10:55:15.050953+02
337	EN	to soil	\N	salir, souiller	\N	1	2018-07-24 08:55:15.050953+02
336	EN	soil	\N	sol, terre	\N	1	2018-07-24 06:55:15.050953+02
335	EN	to flunk	\N	rater, ne pas avoir	\N	1	2018-07-24 04:55:15.050953+02
334	EN	to recede	\N	reculer, s'eloigner, s'estomper, disparaitre	\N	1	2018-07-24 02:55:15.050953+02
333	EN	wart	\N	verrue	\N	1	2018-07-24 00:55:15.050953+02
332	EN	sallow	\N	cireux, cireuse	\N	1	2018-07-23 22:55:15.050953+02
331	EN	to wrinkle	\N	plisser, froisser	\N	1	2018-07-23 20:55:15.050953+02
330	EN	wrinkle	\N	ride	\N	1	2018-07-23 18:55:15.050953+02
329	EN	to shimmer	\N	chatoyer, scintiller, miroiter	\N	1	2018-07-23 16:55:15.050953+02
328	EN	to jerk (sth)	\N	tirer d'un coup sec, faire un mouvement brusque	\N	1	2018-07-23 14:55:15.050953+02
327	EN	to thrust (sth) on (sb)	\N	imposer	\N	1	2018-07-23 12:55:15.050953+02
326	EN	to thrust (sth/sb)	\N	pousser	\N	1	2018-07-23 10:55:15.050953+02
325	EN	rod	\N	tige, canne, coup de baton	\N	1	2018-07-23 08:55:15.050953+02
324	EN	to convey (sth)	\N	communiquer, transmettre, faire part	\N	1	2018-07-23 06:55:15.050953+02
323	EN	slender	\N	mince, svelte, gracile	\N	1	2018-07-23 04:55:15.050953+02
322	EN	gilt	\N	dorure, dore	\N	1	2018-07-23 02:55:15.050953+02
321	EN	to decree	\N	decreter, ordonner	\N	1	2018-07-23 00:55:15.050953+02
320	EN	fling	\N	passade, amourette	\N	1	2018-07-22 22:55:15.050953+02
319	EN	to fling yourself	\N	se jeter, se precipiter	\N	1	2018-07-22 20:55:15.050953+02
318	EN	to fling	\N	lancer	\N	1	2018-07-22 18:55:15.050953+02
317	EN	to fluster	\N	troubler, agiter	\N	1	2018-07-22 16:55:15.050953+02
316	EN	jiffy	\N	instant, seconde, minute	\N	1	2018-07-22 14:55:15.050953+02
314	EN	to limp	\N	boiter	\N	1	2018-07-22 10:55:15.050953+02
313	EN	to shudder	\N	trembler, fremir	\N	1	2018-07-22 08:55:15.050953+02
312	EN	annuity	\N	rente, viager	\N	1	2018-07-22 06:55:15.050953+02
311	EN	untangle	\N	demeler	\N	1	2018-07-22 04:55:15.050953+02
310	EN	gown	\N	robe de chambre, peignoir	\N	1	2018-07-22 02:55:15.050953+02
309	EN	to roar	\N	rugir, hurler	\N	1	2018-07-22 00:55:15.050953+02
308	EN	to trim	\N	couper, tailler	\N	1	2018-07-21 22:55:15.050953+02
307	EN	slender	\N	mince, svelte	\N	1	2018-07-21 20:55:15.050953+02
306	EN	to reel	\N	enrouler, bobiner	\N	1	2018-07-21 18:55:15.050953+02
305	EN	to shiver	\N	trembler, frissoner	\N	1	2018-07-21 16:55:15.050953+02
304	EN	garland	\N	guirlande	\N	1	2018-07-21 14:55:15.050953+02
303	EN	flourish	\N	prosperer	\N	1	2018-07-21 12:55:15.050953+02
302	EN	custodian	\N	gardien, conservateur	\N	1	2018-07-21 10:55:15.050953+02
301	EN	limestone	\N	calcaire	\N	1	2018-07-21 08:55:15.050953+02
300	EN	puddle	\N	flaque d'eau	\N	1	2018-07-21 06:55:15.050953+02
299	EN	wince	\N	grimacer	\N	1	2018-07-21 04:55:15.050953+02
298	EN	forestall	\N	prevenir	\N	1	2018-07-21 02:55:15.050953+02
297	EN	shack	\N	cabane, cahute, case	\N	1	2018-07-21 00:55:15.050953+02
296	EN	beam	\N	rayon de lumiere, rayon, poutre	\N	1	2018-07-20 22:55:15.050953+02
295	EN	earnest	\N	serieux, serieuse	\N	1	2018-07-20 20:55:15.050953+02
294	EN	deed	\N	acte, action	\N	1	2018-07-20 18:55:15.050953+02
293	EN	to bear	\N	supporter	\N	1	2018-07-20 16:55:15.050953+02
292	EN	stunt	\N	cascade, coup de pub, combine	\N	1	2018-07-20 14:55:15.050953+02
291	EN	sheer	\N	pur, simple, extra-fin	\N	1	2018-07-20 12:55:15.050953+02
290	EN	wellfare	\N	bien-etre, allocation	\N	1	2018-07-20 10:55:15.050953+02
289	EN	plea	\N	appel, defense, excuse	\N	1	2018-07-20 08:55:15.050953+02
288	EN	entwined	\N	entrelacer, lier	\N	1	2018-07-20 06:55:15.050953+02
277	EN	spurious	\N	faux	\N	1	2018-07-20 04:55:15.050953+02
276	EN	peculiar	\N	étrange, bizarre	\N	1	2018-07-20 02:55:15.050953+02
275	EN	tout	\N	raccoler	\N	1	2018-07-20 00:55:15.050953+02
274	EN	seasoned	\N	expérimenté	\N	1	2018-07-19 22:55:15.050953+02
273	EN	circumscribe	\N	délimiter	\N	1	2018-07-19 20:55:15.050953+02
272	EN	womb	\N	utérus	\N	1	2018-07-19 18:55:15.050953+02
271	EN	weightless	\N	en apesanteur	\N	1	2018-07-19 16:55:15.050953+02
270	EN	dismay	\N	désarroi	\N	1	2018-07-19 14:55:15.050953+02
269	EN	linger	\N	s'attarder	\N	1	2018-07-19 12:55:15.050953+02
268	EN	gist	\N	idée générale	\N	1	2018-07-19 10:55:15.050953+02
267	EN	one-off	\N	quelque chose d'exceptionnel	\N	1	2018-07-19 08:55:15.050953+02
266	EN	one-off	\N	quelque chose	\N	1	2018-07-19 06:55:15.050953+02
265	EN	garner	\N	recueillir, récolter	\N	1	2018-07-19 04:55:15.050953+02
264	EN	hinge	\N	gond, charnière	\N	1	2018-07-19 02:55:15.050953+02
263	EN	strife	\N	querelle	\N	1	2018-07-19 00:55:15.050953+02
262	EN	midst	\N	au milieu de	\N	1	2018-07-18 22:55:15.050953+02
261	EN	remit	\N	attribution	\N	1	2018-07-18 20:55:15.050953+02
260	EN	hitch	\N	contretemps	\N	1	2018-07-18 18:55:15.050953+02
259	EN	rung	\N	barreau	\N	1	2018-07-18 16:55:15.050953+02
258	EN	rung	\N	barreau	\N	1	2018-07-18 14:55:15.050953+02
257	EN	binder	\N	classeur	\N	1	2018-07-18 12:55:15.050953+02
256	EN	headway	\N	progrès	\N	1	2018-07-18 10:55:15.050953+02
255	EN	touted	\N	racoler, vendre	\N	1	2018-07-18 08:55:15.050953+02
254	EN	stake	\N	intéret, poteau, piquet	\N	1	2018-07-18 06:55:15.050953+02
253	EN	stiff	\N	rigide, raide, crispé	\N	1	2018-07-18 04:55:15.050953+02
252	EN	garment	\N	vetement, habit	\N	1	2018-07-18 02:55:15.050953+02
251	EN	twilight	\N	crépuscule	\N	1	2018-07-18 00:55:15.050953+02
250	EN	fling	\N	lancer, passade	\N	1	2018-07-17 22:55:15.050953+02
249	EN	stout	\N	corpulent, fort	\N	1	2018-07-17 20:55:15.050953+02
248	EN	skimp	\N	mégoter, lésiner	\N	1	2018-07-17 18:55:15.050953+02
247	EN	pudgy	\N	enrobé, grassouillet	\N	1	2018-07-17 16:55:15.050953+02
246	EN	knoll	\N	monticule	\N	1	2018-07-17 14:55:15.050953+02
245	EN	flutter	\N	battre des ailes	\N	1	2018-07-17 12:55:15.050953+02
244	EN	cushion	\N	coussin	\N	1	2018-07-17 10:55:15.050953+02
243	EN	saliva	\N	salive	\N	1	2018-07-17 08:55:15.050953+02
242	EN	drool	\N	baver	\N	1	2018-07-17 06:55:15.050953+02
241	EN	swollen	\N	enflé, gonflé	\N	1	2018-07-17 04:55:15.050953+02
240	EN	bulge	\N	bosse, se gonfler	\N	1	2018-07-17 02:55:15.050953+02
239	EN	lawn	\N	gazon, pelouse	\N	1	2018-07-17 00:55:15.050953+02
238	EN	shingle	\N	galets	\N	1	2018-07-16 22:55:15.050953+02
237	EN	mound	\N	tas, pile	\N	1	2018-07-16 20:55:15.050953+02
236	EN	dump	\N	décharge publique	\N	1	2018-07-16 18:55:15.050953+02
235	EN	sprawl	\N	s'etendre, etre affalé, etre vautré	\N	1	2018-07-16 16:55:15.050953+02
234	EN	boulder	\N	énorme rocher	\N	1	2018-07-16 14:55:15.050953+02
233	EN	girder	\N	poutre	\N	1	2018-07-16 12:55:15.050953+02
232	EN	thrust	\N	pousser, imposer, enfoncer	\N	1	2018-07-16 10:55:15.050953+02
231	EN	rind	\N	écorce, couenne	\N	1	2018-07-16 08:55:15.050953+02
230	EN	hollow	\N	creux, vide	\N	1	2018-07-16 06:55:15.050953+02
229	EN	ore	\N	minerai	\N	1	2018-07-16 04:55:15.050953+02
228	EN	hare	\N	lièvre	\N	1	2018-07-16 02:55:15.050953+02
227	EN	loom	\N	se profiler	\N	1	2018-07-16 00:55:15.050953+02
226	EN	redeem	\N	racheter, échanger	\N	1	2018-07-15 22:55:15.050953+02
225	EN	abstruse	\N	obscur	\N	1	2018-07-15 20:55:15.050953+02
224	EN	hubris	\N	orgueil démesuré	\N	1	2018-07-15 18:55:15.050953+02
223	EN	wordWord	\N	wordDefinition	\N	1	2018-07-15 16:55:15.050953+02
215	EN	stir	\N	mélanger	\N	1	2018-07-15 14:55:15.050953+02
214	EN	pluck	\N	plumer, pincer, épiler	\N	1	2018-07-15 12:55:15.050953+02
213	EN	lift	\N	élever, se hisser	\N	1	2018-07-15 10:55:15.050953+02
212	EN	ilk	\N	genre, acabit	\N	1	2018-07-15 08:55:15.050953+02
211	EN	hog	\N	cochon (figuré)	\N	1	2018-07-15 06:55:15.050953+02
210	EN	peachy	\N	super, génial	\N	1	2018-07-15 04:55:15.050953+02
209	EN	whirl	\N	tourbillonner	\N	1	2018-07-15 02:55:15.050953+02
208	EN	beef up	\N	renforcer	\N	1	2018-07-15 00:55:15.050953+02
207	EN	abide	\N	ne pas supporter	\N	1	2018-07-14 22:55:15.050953+02
206	EN	wrought	\N	forgé, provoqué	\N	1	2018-07-14 20:55:15.050953+02
205	EN	right off the bat	\N	tout de suite	\N	1	2018-07-14 18:55:15.050953+02
204	EN	gee golly	\N	ca alors!	\N	1	2018-07-14 16:55:15.050953+02
203	EN	reap	\N	récolter les fruits	\N	1	2018-07-14 14:55:15.050953+02
202	EN	strive	\N	lutter	\N	1	2018-07-14 12:55:15.050953+02
201	EN	yardstick	\N	mètre	\N	1	2018-07-14 10:55:15.050953+02
200	EN	moot	\N	stérile (academic, no practical significance)	\N	1	2018-07-14 08:55:15.050953+02
199	EN	moot	\N	stérile	\N	1	2018-07-14 06:55:15.050953+02
198	EN	scourge	\N	fléau	\N	1	2018-07-14 04:55:15.050953+02
197	EN	cram	\N	entasser	\N	1	2018-07-14 02:55:15.050953+02
196	EN	comb	\N	peigne	\N	1	2018-07-14 00:55:15.050953+02
195	EN	nudge	\N	encourager, petit coup de coude	\N	1	2018-07-13 22:55:15.050953+02
194	EN	slain	\N	tuer, massacrer	\N	1	2018-07-13 20:55:15.050953+02
193	EN	interwoven	\N	entrelacé	\N	1	2018-07-13 18:55:15.050953+02
192	EN	sap	\N	enlever, retirer, nigaud	\N	1	2018-07-13 16:55:15.050953+02
191	EN	awash	\N	inondé	\N	1	2018-07-13 14:55:15.050953+02
190	EN	tongue-in-cheek	\N	ironique	\N	1	2018-07-13 12:55:15.050953+02
189	EN	shoe-horn	\N	chausse-pied	\N	1	2018-07-13 10:55:15.050953+02
188	EN	shoe-horn	\N	chausse-pied	\N	1	2018-07-13 08:55:15.050953+02
187	EN	convoluted	\N	alambiqué	\N	1	2018-07-13 06:55:15.050953+02
186	EN	mend	\N	raccomoder, réparer, repriser	\N	1	2018-07-13 04:55:15.050953+02
185	EN	hocus-pocus	\N	supercherie	\N	1	2018-07-13 02:55:15.050953+02
184	EN	meatier	\N	substantiel	\N	1	2018-07-13 00:55:15.050953+02
183	EN	out of the blue	\N	venu de nulle part	\N	1	2018-07-12 22:55:15.050953+02
182	EN	secular	\N	profane	\N	1	2018-07-12 20:55:15.050953+02
181	EN	murk	\N	obscurité	\N	1	2018-07-12 18:55:15.050953+02
180	EN	arrogate	\N	s'arroger, s'attribuer	\N	1	2018-07-12 16:55:15.050953+02
179	EN	uplift	\N	exalter, encourager	\N	1	2018-07-12 14:55:15.050953+02
178	EN	despise	\N	mépriser	\N	1	2018-07-12 12:55:15.050953+02
177	EN	bond	\N	liens	\N	1	2018-07-12 10:55:15.050953+02
176	EN	indictment	\N	inculpation	\N	1	2018-07-12 08:55:15.050953+02
175	EN	stroke	\N	coup (figuré, comme coup de main)	\N	1	2018-07-12 06:55:15.050953+02
174	EN	tug	\N	tirer sur	\N	1	2018-07-12 04:55:15.050953+02
173	EN	scurvy	\N	scorbut (manque de vitamine C)	\N	1	2018-07-12 02:55:15.050953+02
172	EN	to elide	\N	élider, omettre	\N	1	2018-07-12 00:55:15.050953+02
171	EN	to squawk	\N	crier	\N	1	2018-07-11 22:55:15.050953+02
170	EN	contrived	\N	contraint	\N	1	2018-07-11 20:55:15.050953+02
169	EN	swath	\N	envelopper	\N	1	2018-07-11 18:55:15.050953+02
168	PL	rower	\N	vélo	\N	1	2018-07-11 16:55:15.050953+02
167	EN	ruthless	\N	sans pitié	\N	1	2018-07-11 14:55:15.050953+02
166	EN	belittle	\N	rabaisser, dénigrer	\N	1	2018-07-11 12:55:15.050953+02
165	EN	compound	\N	mélange, aggraver	\N	1	2018-07-11 10:55:15.050953+02
164	EN	laudable	\N	louable	\N	1	2018-07-11 08:55:15.050953+02
163	EN	breed	\N	faire de l'élevage	\N	1	2018-07-11 06:55:15.050953+02
162	EN	gaze	\N	regard fixe	\N	1	2018-07-11 04:55:15.050953+02
161	EN	skulk	\N	roder	\N	1	2018-07-11 02:55:15.050953+02
160	EN	doth	\N	gond, charnière	\N	1	2018-07-11 00:55:15.050953+02
159	EN	hushed	\N	calme, feutré, étouffé	\N	1	2018-07-10 22:55:15.050953+02
158	EN	aback	\N	vers l'arrière	\N	1	2018-07-10 20:55:15.050953+02
157	EN	scathing	\N	très critique, cinglant	\N	1	2018-07-10 18:55:15.050953+02
156	EN	startle	\N	surprendre, étonner	\N	1	2018-07-10 16:55:15.050953+02
155	EN	bewildered	\N	perplexe	\N	1	2018-07-10 14:55:15.050953+02
154	EN	astute	\N	astucieux, malin	\N	1	2018-07-10 12:55:15.050953+02
153	EN	cattle	\N	bétail, veaux, mouton	\N	1	2018-07-10 10:55:15.050953+02
152	EN	hump	\N	bosse, le plus dur	\N	1	2018-07-10 08:55:15.050953+02
151	EN	trove	\N	trésor	\N	1	2018-07-10 06:55:15.050953+02
150	EN	stint	\N	période, séjour	\N	1	2018-07-10 04:55:15.050953+02
149	EN	henceforth	\N	dorénavant	\N	1	2018-07-10 02:55:15.050953+02
148	EN	blossom	\N	fleur, fleurir	\N	1	2018-07-10 00:55:15.050953+02
147	EN	ignited	\N	prendre feu, s'enflammer	\N	1	2018-07-09 22:55:15.050953+02
146	EN	shief	\N	liasse, gerbe	\N	1	2018-07-09 20:55:15.050953+02
145	EN	pore	\N	examiner	\N	1	2018-07-09 18:55:15.050953+02
144	EN	pacing	\N	allure	\N	1	2018-07-09 16:55:15.050953+02
143	EN	thorny	\N	épineux	\N	1	2018-07-09 14:55:15.050953+02
142	EN	forthright	\N	franc, direct	\N	1	2018-07-09 12:55:15.050953+02
141	EN	bolstered	\N	soutenir, renforcer	\N	1	2018-07-09 10:55:15.050953+02
140	EN	dawn	\N	aube, aurore	\N	1	2018-07-09 08:55:15.050953+02
139	EN	fathom	\N	comprendre, percer	\N	1	2018-07-09 06:55:15.050953+02
138	EN	starkly	\N	grandement	\N	1	2018-07-09 04:55:15.050953+02
137	EN	treacherous	\N	traitre	\N	1	2018-07-09 02:55:15.050953+02
136	EN	nook	\N	recoin	\N	1	2018-07-09 00:55:15.050953+02
135	EN	feisty	\N	agressif, fougeux	\N	1	2018-07-08 22:55:15.050953+02
134	EN	gather	\N	regrouper, cueillir	\N	1	2018-07-08 20:55:15.050953+02
133	EN	kitchen towel	\N	sopalin	\N	1	2018-07-08 18:55:15.050953+02
132	EN	top	\N	bouchon / capsule	\N	1	2018-07-08 16:55:15.050953+02
131	EN	cap	\N	bouchon / capsule	\N	1	2018-07-08 14:55:15.050953+02
130	EN	cap	\N	bouchon	\N	1	2018-07-08 12:55:15.050953+02
129	EN	plug	\N	bouchon	\N	1	2018-07-08 10:55:15.050953+02
128	EN	stopper	\N	bouchon	\N	1	2018-07-08 08:55:15.050953+02
127	EN	cork	\N	bouchon	\N	1	2018-07-08 06:55:15.050953+02
126	EN	top	\N	couvercle	\N	1	2018-07-08 04:55:15.050953+02
125	EN	cover	\N	couvercle	\N	1	2018-07-08 02:55:15.050953+02
124	EN	lid	\N	couvercle	\N	1	2018-07-08 00:55:15.050953+02
123	EN	shower head	\N	pommeau de douche	\N	1	2018-07-07 22:55:15.050953+02
122	EN	knob	\N	poignée	\N	1	2018-07-07 20:55:15.050953+02
121	EN	faucet	\N	robinet	\N	1	2018-07-07 18:55:15.050953+02
120	EN	tap	\N	robinet	\N	1	2018-07-07 16:55:15.050953+02
119	EN	sink	\N	évier	\N	1	2018-07-07 14:55:15.050953+02
118	EN	dishes	\N	vaisselle	\N	1	2018-07-07 12:55:15.050953+02
117	EN	blender	\N	mixeur	\N	1	2018-07-07 10:55:15.050953+02
116	EN	peeler	\N	économe / éplucheur	\N	1	2018-07-07 08:55:15.050953+02
115	EN	jar	\N	conserver (verre) / bocal	\N	1	2018-07-07 06:55:15.050953+02
114	EN	preserving jar	\N	bocal	\N	1	2018-07-07 04:55:15.050953+02
113	EN	can	\N	conserve (métal)	\N	1	2018-07-07 02:55:15.050953+02
112	EN	tin	\N	conserve (métal)	\N	1	2018-07-07 00:55:15.050953+02
111	EN	jar	\N	conserve (verre)	\N	1	2018-07-06 22:55:15.050953+02
110	EN	closet	\N	armoire	\N	1	2018-07-06 20:55:15.050953+02
109	EN	wardrobe	\N	armoire	\N	1	2018-07-06 18:55:15.050953+02
108	EN	chest of drawer	\N	commode	\N	1	2018-07-06 16:55:15.050953+02
107	EN	storage unit	\N	meuble de rangement	\N	1	2018-07-06 14:55:15.050953+02
106	EN	drawer	\N	tiroir	\N	1	2018-07-06 12:55:15.050953+02
105	EN	drainrack	\N	égouttoir	\N	1	2018-07-06 10:55:15.050953+02
104	EN	tea towel	\N	torchon	\N	1	2018-07-06 08:55:15.050953+02
103	EN	hood	\N	hotte	\N	1	2018-07-06 06:55:15.050953+02
102	EN	hotte	\N	hood cooker	\N	1	2018-07-06 04:55:15.050953+02
101	EN	ladle	\N	louche	\N	1	2018-07-06 02:55:15.050953+02
100	EN	oven	\N	four	\N	1	2018-07-06 00:55:15.050953+02
99	EN	pressure-cooker	\N	cocotte-minute	\N	1	2018-07-05 22:55:15.050953+02
96	EN	cabinet	\N	armoire	\N	1	2018-07-05 20:55:15.050953+02
95	EN	wardrobe	\N	armoire	\N	1	2018-07-05 18:55:15.050953+02
94	EN	leeway	\N	marge	\N	1	2018-07-05 16:55:15.050953+02
93	EN	tusk	\N	défense d'animal	\N	1	2018-07-05 14:55:15.050953+02
92	EN	lather	\N	savonner	\N	1	2018-07-05 12:55:15.050953+02
91	EN	inane	\N	inepte, stupide	\N	1	2018-07-05 10:55:15.050953+02
90	EN	hindsight	\N	avoir du recul	\N	1	2018-07-05 08:55:15.050953+02
89	EN	trough	\N	désespoir	\N	1	2018-07-05 06:55:15.050953+02
88	EN	opine	\N	faire remarquer	\N	1	2018-07-05 04:55:15.050953+02
87	EN	panacea	\N	panacée (cure for everything)	\N	1	2018-07-05 02:55:15.050953+02
86	EN	pesky	\N	fichu, sale, embettant	\N	1	2018-07-05 00:55:15.050953+02
85	EN	perk	\N	avantage	\N	1	2018-07-04 22:55:15.050953+02
84	EN	demanding	\N	exigeant	\N	1	2018-07-04 20:55:15.050953+02
83	EN	hitchhiker	\N	auto stoppeur	\N	1	2018-07-04 18:55:15.050953+02
82	EN	incentive	\N	motivation	\N	1	2018-07-04 16:55:15.050953+02
81	EN	dwindle	\N	diminuer/baisser	\N	1	2018-07-04 14:55:15.050953+02
80	EN	brink	\N	(figuré) bord	\N	1	2018-07-04 12:55:15.050953+02
79	EN	eavesdropping	\N	ecouter aux portes	\N	1	2018-07-04 10:55:15.050953+02
78	EN	halve	\N	reduire de moitie	\N	1	2018-07-04 08:55:15.050953+02
77	PL	kobieta	\N	femme	\N	1	2018-07-04 06:55:15.050953+02
76	EN	glimmer	\N	faible lueur	\N	1	2018-07-04 04:55:15.050953+02
75	EN	phase out	\N	expression - mettre un terme	\N	1	2018-07-04 02:55:15.050953+02
74	EN	lampoon	\N	ridiculiser	\N	1	2018-07-04 00:55:15.050953+02
73	EN	stymied	\N	contrecarrer / faire obstable a	\N	1	2018-07-03 22:55:15.050953+02
72	EN	whack	\N	donner un grand coup a / donner une claque a	\N	1	2018-07-03 20:55:15.050953+02
71	EN	curtailed	\N	ecourter	\N	1	2018-07-03 18:55:15.050953+02
70	EN	wager	\N	(un) pari	\N	1	2018-07-03 16:55:15.050953+02
69	EN	strife	\N	querelle	\N	1	2018-07-03 14:55:15.050953+02
68	EN	stride	\N	pas	\N	1	2018-07-03 12:55:15.050953+02
67	EN	albeit	\N	bien que	\N	1	2018-07-03 10:55:15.050953+02
66	EN	vernacular	\N	jargon	\N	1	2018-07-03 08:55:15.050953+02
65	EN	mince	\N	haché	\N	1	2018-07-03 06:55:15.050953+02
64	EN	veneer	\N	vernis / apparence	\N	1	2018-07-03 04:55:15.050953+02
63	EN	leek	\N	poireau	\N	1	2018-07-03 02:55:15.050953+02
62	EN	barley	\N	orge	\N	1	2018-07-03 00:55:15.050953+02
61	EN	groat	\N	gruaut	\N	1	2018-07-02 22:55:15.050953+02
60	EN	harness	\N	maitriser exploiter	\N	1	2018-07-02 20:55:15.050953+02
59	EN	convoluted (twisted)	\N	tordu	\N	1	2018-07-02 18:55:15.050953+02
58	EN	confound	\N	perturber	\N	1	2018-07-02 16:55:15.050953+02
57	EN	wreck	\N	accident / vieille voiture / tacot	\N	1	2018-07-02 14:55:15.050953+02
56	EN	wart	\N	verrue	\N	1	2018-07-02 12:55:15.050953+02
55	EN	compelling	\N	irrefutable	\N	1	2018-07-02 10:55:15.050953+02
54	EN	foster	\N	promouvoir encourager	\N	1	2018-07-02 08:55:15.050953+02
53	EN	stewardship	\N	intendance administration	\N	1	2018-07-02 06:55:15.050953+02
52	EN	to despise	\N	mépriser	\N	1	2018-07-02 04:55:15.050953+02
51	FR	canonique	\N	conforme a une regle	\N	1	2018-07-02 02:55:15.050953+02
50	EN	mind you	\N	expression - bien entendu	\N	1	2018-07-02 00:55:15.050953+02
49	EN	wisdom	\N	sagesse / bon sens	\N	1	2018-07-01 22:55:15.050953+02
48	EN	at odds	\N	expression - en desaccord	\N	1	2018-07-01 20:55:15.050953+02
47	EN	kick in the teeth	\N	expression - coup bas.	\N	1	2018-07-01 18:55:15.050953+02
46	EN	pernicious	\N	pernicieux / malveillant	\N	1	2018-07-01 16:55:15.050953+02
45	EN	schlepping	\N	(familier) se trimballer	\N	1	2018-07-01 14:55:15.050953+02
44	EN	creep	\N	grimper / ramper / se glisser	\N	1	2018-07-01 12:55:15.050953+02
43	EN	(to) Impede	\N	to retard in movement or progress by means of obstacles or hindrances;	\N	1	2018-07-01 10:55:15.050953+02
42	EN	cogent	\N	convaincant / preuve	\N	1	2018-07-01 08:55:15.050953+02
41	EN	quagmire	\N	bourbier	\N	1	2018-07-01 06:55:15.050953+02
40	FR	exsuder	\N	évaporation	\N	1	2018-07-01 04:55:15.050953+02
39	EN	cogent	\N	convaincant / preuve	\N	1	2018-07-01 02:55:15.050953+02
38	EN	quagmire	\N	bourbier	\N	1	2018-07-01 00:55:15.050953+02
37	EN	slogging	\N	trimmer, travailler dur	\N	1	2018-06-30 22:55:15.050953+02
36	EN	daunting	\N	intimidant	\N	1	2018-06-30 20:55:15.050953+02
35	EN	cog	\N	roue dentée	\N	1	2018-06-30 18:55:15.050953+02
34	EN	quibble	\N	critique	\N	1	2018-06-30 16:55:15.050953+02
33	EN	brass	\N	cuivre	\N	1	2018-06-30 14:55:15.050953+02
32	EN	twitch	\N	avoir un mouvement convulsif	\N	1	2018-06-30 12:55:15.050953+02
31	EN	wand	\N	baguette magique	\N	1	2018-06-30 10:55:15.050953+02
30	EN	thrust	\N	pousser, forcer, imposer	\N	1	2018-06-30 08:55:15.050953+02
29	EN	fiddly	\N	minutieux, délicat	\N	1	2018-06-30 06:55:15.050953+02
28	EN	dismay	\N	désarroi, consterner	\N	1	2018-06-30 04:55:15.050953+02
27	EN	grasp	\N	saisir, comprendre	\N	1	2018-06-30 02:55:15.050953+02
26	EN	fringe	\N	banlieue, marge	\N	1	2018-06-30 00:55:15.050953+02
25	EN	prying	\N	indiscret	\N	1	2018-06-29 22:55:15.050953+02
24	EN	eschew	\N	éviter, fuir	\N	1	2018-06-29 20:55:15.050953+02
23	EN	ubiquitous	\N	omniprésent	\N	1	2018-06-29 18:55:15.050953+02
22	EN	clameur	\N	réclamer	\N	1	2018-06-29 16:55:15.050953+02
21	EN	casualty	\N	blessé, mort	\N	1	2018-06-29 14:55:15.050953+02
20	EN	apathetic	\N	apathique, indifférent	\N	1	2018-06-29 12:55:15.050953+02
19	EN	wrestle	\N	luter	\N	1	2018-06-29 10:55:15.050953+02
18	EN	trite	\N	banal	\N	1	2018-06-29 08:55:15.050953+02
17	EN	incur	\N	encourir	\N	1	2018-06-29 06:55:15.050953+02
16	EN	stiff	\N	rigide	\N	1	2018-06-29 04:55:15.050953+02
15	EN	crackle	\N	crépiter	\N	1	2018-06-29 02:55:15.050953+02
14	EN	distress	\N	bouleverser	\N	1	2018-06-29 00:55:15.050953+02
13	EN	net	\N	filet	\N	1	2018-06-28 22:55:15.050953+02
12	EN	swerve	\N	faire un écart	\N	1	2018-06-28 20:55:15.050953+02
11	EN	dart	\N	foncer, se précipiter	\N	1	2018-06-28 18:55:15.050953+02
10	EN	edible	\N	mangeable, comestible	\N	1	2018-06-28 16:55:15.050953+02
9	EN	shire	\N	comté	\N	1	2018-06-28 14:55:15.050953+02
8	EN	nudge	\N	petit coup de coude	\N	1	2018-06-28 12:55:15.050953+02
7	EN	delineate	\N	définir	\N	1	2018-06-28 10:55:15.050953+02
6	EN	averse	\N	éprouver de la répugnance pour	\N	1	2018-06-28 08:55:15.050953+02
5	EN	fraught	\N	stressant, tendu	\N	1	2018-06-28 06:55:15.050953+02
4	EN	womb	\N	uterus, ventre	\N	1	2018-06-28 04:55:15.050953+02
3	EN	allowance	\N	argent de poche	\N	1	2018-06-28 02:55:15.050953+02
2	EN	transfixed	\N	subjugué, captivé	\N	1	2018-06-28 00:55:15.050953+02
1	EN	slogging	\N	trimmer, travailler dur	\N	1	2018-06-27 22:55:15.050953+02
\.


--
-- Data for Name: changes; Type: TABLE DATA; Schema: sqitch; Owner: arkadefr
--

COPY sqitch.changes (change_id, script_hash, change, project, note, committed_at, committer_name, committer_email, planned_at, planner_name, planner_email) FROM stdin;
2a1d4c93c2f27b05502138d9f32d75c0e9b354e5	a3ca206e036b832ea2b564aa3010056004afcb8d	0001-words	words	Schema for words	2018-02-05 23:09:48.806478+01	aRkadeFR	contact@arkade.info	2018-02-05 22:59:14+01	aRkadeFR	contact@arkade.info
1f0c2834f271ea03fe7118506db4f4660cdd61f0	1cd367b2de5cdef3b0bcee7fa7a0f612e3ba2fcb	0002-users	words	Add 0002-users deploy change	2018-07-16 09:42:46.295081+02	aRkadeFR	contact@arkade.info	2018-07-16 09:41:01+02	aRkadeFR	contact@arkade.info
\.


--
-- Data for Name: dependencies; Type: TABLE DATA; Schema: sqitch; Owner: arkadefr
--

COPY sqitch.dependencies (change_id, type, dependency, dependency_id) FROM stdin;
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: sqitch; Owner: arkadefr
--

COPY sqitch.events (event, change_id, change, project, note, requires, conflicts, tags, committed_at, committer_name, committer_email, planned_at, planner_name, planner_email) FROM stdin;
deploy	2a1d4c93c2f27b05502138d9f32d75c0e9b354e5	0001-words	words	Schema for words	{}	{}	{}	2018-02-05 23:09:34.577274+01	aRkadeFR	contact@arkade.info	2018-02-05 22:59:14+01	aRkadeFR	contact@arkade.info
revert	2a1d4c93c2f27b05502138d9f32d75c0e9b354e5	0001-words	words	Schema for words	{}	{}	{}	2018-02-05 23:09:41.109546+01	aRkadeFR	contact@arkade.info	2018-02-05 22:59:14+01	aRkadeFR	contact@arkade.info
deploy	2a1d4c93c2f27b05502138d9f32d75c0e9b354e5	0001-words	words	Schema for words	{}	{}	{}	2018-02-05 23:09:48.807546+01	aRkadeFR	contact@arkade.info	2018-02-05 22:59:14+01	aRkadeFR	contact@arkade.info
deploy	1f0c2834f271ea03fe7118506db4f4660cdd61f0	0002-users	words	Add 0002-users deploy change	{}	{}	{}	2018-07-16 09:42:46.297005+02	aRkadeFR	contact@arkade.info	2018-07-16 09:41:01+02	aRkadeFR	contact@arkade.info
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: sqitch; Owner: arkadefr
--

COPY sqitch.projects (project, uri, created_at, creator_name, creator_email) FROM stdin;
words	\N	2018-02-05 23:09:34.468959+01	aRkadeFR	contact@arkade.info
\.


--
-- Data for Name: releases; Type: TABLE DATA; Schema: sqitch; Owner: arkadefr
--

COPY sqitch.releases (version, installed_at, installer_name, installer_email) FROM stdin;
1.10000002	2018-02-05 23:09:34.466124+01	aRkadeFR	contact@arkade.info
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: sqitch; Owner: arkadefr
--

COPY sqitch.tags (tag_id, tag, project, change_id, note, committed_at, committer_name, committer_email, planned_at, planner_name, planner_email) FROM stdin;
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: arkadefr
--

SELECT pg_catalog.setval('public.users_id_seq', 2, true);


--
-- Name: words_id_seq; Type: SEQUENCE SET; Schema: public; Owner: arkadefr
--

SELECT pg_catalog.setval('public.words_id_seq', 400, true);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: arkadefr
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: words words_pkey; Type: CONSTRAINT; Schema: public; Owner: arkadefr
--

ALTER TABLE ONLY public.words
    ADD CONSTRAINT words_pkey PRIMARY KEY (id);


--
-- Name: changes changes_pkey; Type: CONSTRAINT; Schema: sqitch; Owner: arkadefr
--

ALTER TABLE ONLY sqitch.changes
    ADD CONSTRAINT changes_pkey PRIMARY KEY (change_id);


--
-- Name: changes changes_project_script_hash_key; Type: CONSTRAINT; Schema: sqitch; Owner: arkadefr
--

ALTER TABLE ONLY sqitch.changes
    ADD CONSTRAINT changes_project_script_hash_key UNIQUE (project, script_hash);


--
-- Name: dependencies dependencies_pkey; Type: CONSTRAINT; Schema: sqitch; Owner: arkadefr
--

ALTER TABLE ONLY sqitch.dependencies
    ADD CONSTRAINT dependencies_pkey PRIMARY KEY (change_id, dependency);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: sqitch; Owner: arkadefr
--

ALTER TABLE ONLY sqitch.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (change_id, committed_at);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: sqitch; Owner: arkadefr
--

ALTER TABLE ONLY sqitch.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (project);


--
-- Name: projects projects_uri_key; Type: CONSTRAINT; Schema: sqitch; Owner: arkadefr
--

ALTER TABLE ONLY sqitch.projects
    ADD CONSTRAINT projects_uri_key UNIQUE (uri);


--
-- Name: releases releases_pkey; Type: CONSTRAINT; Schema: sqitch; Owner: arkadefr
--

ALTER TABLE ONLY sqitch.releases
    ADD CONSTRAINT releases_pkey PRIMARY KEY (version);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: sqitch; Owner: arkadefr
--

ALTER TABLE ONLY sqitch.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (tag_id);


--
-- Name: tags tags_project_tag_key; Type: CONSTRAINT; Schema: sqitch; Owner: arkadefr
--

ALTER TABLE ONLY sqitch.tags
    ADD CONSTRAINT tags_project_tag_key UNIQUE (project, tag);


--
-- Name: users tr_user_hash_password; Type: TRIGGER; Schema: public; Owner: arkadefr
--

CREATE TRIGGER tr_user_hash_password BEFORE INSERT OR UPDATE ON public.users FOR EACH ROW EXECUTE PROCEDURE public.user_hash_password();


--
-- Name: words userid_fk; Type: FK CONSTRAINT; Schema: public; Owner: arkadefr
--

ALTER TABLE ONLY public.words
    ADD CONSTRAINT userid_fk FOREIGN KEY (userid) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: changes changes_project_fkey; Type: FK CONSTRAINT; Schema: sqitch; Owner: arkadefr
--

ALTER TABLE ONLY sqitch.changes
    ADD CONSTRAINT changes_project_fkey FOREIGN KEY (project) REFERENCES sqitch.projects(project) ON UPDATE CASCADE;


--
-- Name: dependencies dependencies_change_id_fkey; Type: FK CONSTRAINT; Schema: sqitch; Owner: arkadefr
--

ALTER TABLE ONLY sqitch.dependencies
    ADD CONSTRAINT dependencies_change_id_fkey FOREIGN KEY (change_id) REFERENCES sqitch.changes(change_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: dependencies dependencies_dependency_id_fkey; Type: FK CONSTRAINT; Schema: sqitch; Owner: arkadefr
--

ALTER TABLE ONLY sqitch.dependencies
    ADD CONSTRAINT dependencies_dependency_id_fkey FOREIGN KEY (dependency_id) REFERENCES sqitch.changes(change_id) ON UPDATE CASCADE;


--
-- Name: events events_project_fkey; Type: FK CONSTRAINT; Schema: sqitch; Owner: arkadefr
--

ALTER TABLE ONLY sqitch.events
    ADD CONSTRAINT events_project_fkey FOREIGN KEY (project) REFERENCES sqitch.projects(project) ON UPDATE CASCADE;


--
-- Name: tags tags_change_id_fkey; Type: FK CONSTRAINT; Schema: sqitch; Owner: arkadefr
--

ALTER TABLE ONLY sqitch.tags
    ADD CONSTRAINT tags_change_id_fkey FOREIGN KEY (change_id) REFERENCES sqitch.changes(change_id) ON UPDATE CASCADE;


--
-- Name: tags tags_project_fkey; Type: FK CONSTRAINT; Schema: sqitch; Owner: arkadefr
--

ALTER TABLE ONLY sqitch.tags
    ADD CONSTRAINT tags_project_fkey FOREIGN KEY (project) REFERENCES sqitch.projects(project) ON UPDATE CASCADE;


--
-- PostgreSQL database dump complete
--

