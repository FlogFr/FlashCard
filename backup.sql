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
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


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
    passpass text NOT NULL,
    email text
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
-- Name: token; Type: TABLE; Schema: public; Owner: arkadefr
--

CREATE TABLE public.token (
    id bigint DEFAULT nextval('public.users_id_seq'::regclass) NOT NULL,
    token uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.token OWNER TO arkadefr;

--
-- Name: token_id_seq; Type: SEQUENCE; Schema: public; Owner: arkadefr
--

CREATE SEQUENCE public.token_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.token_id_seq OWNER TO arkadefr;

--
-- Name: token_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: arkadefr
--

ALTER SEQUENCE public.token_id_seq OWNED BY public.token.id;


--
-- Name: words; Type: TABLE; Schema: public; Owner: arkadefr
--

CREATE TABLE public.words (
    id bigint NOT NULL,
    language character(2) NOT NULL,
    word character varying(128) NOT NULL,
    keywords text[] DEFAULT '{}'::text[],
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
-- Data for Name: token; Type: TABLE DATA; Schema: public; Owner: arkadefr
--

COPY public.token (id, token, created_at) FROM stdin;
6	f6e786b9-0a3d-47ef-98fe-e1d9f22ebe94	2018-08-03 19:01:52.999469+02
7	a0c4b789-120d-44e3-865f-dc884fc52d79	2018-08-03 19:01:53.175559+02
8	11465125-1abf-4fc1-8e1b-ca40f9ebf6b3	2018-08-03 19:01:53.367078+02
9	1aa043d5-4bf1-4ced-b66b-3ebd0342b836	2018-08-03 19:01:53.551566+02
10	95172a88-ccd0-4cf8-a982-b40e806aa6cd	2018-08-03 19:01:53.735344+02
11	66c09167-c5c0-47f1-b4ce-07f057d640d7	2018-08-03 19:01:53.887586+02
12	7179a918-5543-4bf6-a575-9ad5dbbc3b24	2018-08-03 19:01:54.071543+02
13	73c3d565-7f1b-4ce4-8740-c31edcb33b3f	2018-08-03 19:23:08.824561+02
14	ac60b71a-0917-427d-ae50-2eee0e6a76f3	2018-08-03 19:23:08.832118+02
15	8c32a4e0-cebb-41da-8b8b-21fe8b4a173d	2018-08-03 19:23:11.021187+02
16	0a719c56-4741-4b13-89d3-84d892b40a3c	2018-08-03 19:23:12.29022+02
17	1dc39d21-98b2-4401-ab45-e47ab5155bf0	2018-08-03 19:23:14.380303+02
18	5aaf1665-16cb-4415-8ce2-4d0382ed4180	2018-08-03 19:23:14.389918+02
19	5777f323-188a-4581-a0cf-4271414464b3	2018-08-03 19:23:14.753278+02
20	3a189548-4850-4ac5-bd78-3ea99ef60ad5	2018-08-03 19:23:13.863943+02
21	e7566a29-84d5-42e2-ad78-a3f8f053fee2	2018-08-03 19:23:15.338242+02
22	135c6c1c-8f8f-4a3f-a6fb-061c126a1cb3	2018-08-03 19:23:15.055187+02
23	b95d547f-1e40-43f5-a6ee-395d1049e179	2018-08-03 19:23:15.853574+02
24	9682ddfd-0e23-452f-b8ca-d149d3a4d62c	2018-08-03 19:53:13.329774+02
25	8d9cec4a-50c6-4dad-8a2c-532e8032f3c9	2018-08-03 20:54:40.375351+02
27	54f10ada-3b2c-4164-9daa-5aba0cb0d42b	2018-08-03 23:08:35.462486+02
28	bb6d526e-b7bc-44de-9803-1e1f5d7025fc	2018-08-03 23:08:35.468937+02
29	c0e7a256-8217-40b7-be15-1b57f4e19822	2018-08-03 23:08:40.265773+02
30	243c1c4b-9357-4992-874f-fa7a907cf758	2018-08-03 23:32:02.871216+02
31	84fe245c-3811-48aa-adf5-530d23f155b7	2018-08-03 23:36:49.673781+02
32	d0979bf9-1f0a-452c-9a49-1df37932e853	2018-08-03 23:36:49.676676+02
34	5408cb54-eaf7-4126-9f80-8d3dff5057c7	2018-08-03 23:50:19.206578+02
36	236fdfe3-94b9-4c2e-81d0-52ef5cbdb685	2018-08-03 23:59:26.754718+02
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: arkadefr
--

COPY public.users (id, username, passpass, email) FROM stdin;
2	wiktoria	$2a$08$RtYXZmoDLdVupCgu7GCXluJWlTyq5/zhot7chK.QPR56FvTCqlwPS	\N
1	flog	$2a$08$dVQtmGG1Tg54EHkCyZCqOu1eKRgtcq0SYxLQvkDqIrxU.M1BwA33q	\N
\.


--
-- Data for Name: words; Type: TABLE DATA; Schema: public; Owner: arkadefr
--

COPY public.words (id, language, word, keywords, definition, difficulty, userid, inserted_at) FROM stdin;
260	EN	hitch	{}	contretemps	\N	1	2018-07-18 18:55:15.050953+02
259	EN	rung	{}	barreau	\N	1	2018-07-18 16:55:15.050953+02
258	EN	rung	{}	barreau	\N	1	2018-07-18 14:55:15.050953+02
257	EN	binder	{}	classeur	\N	1	2018-07-18 12:55:15.050953+02
256	EN	headway	{}	progrès	\N	1	2018-07-18 10:55:15.050953+02
255	EN	touted	{}	racoler, vendre	\N	1	2018-07-18 08:55:15.050953+02
254	EN	stake	{}	intéret, poteau, piquet	\N	1	2018-07-18 06:55:15.050953+02
253	EN	stiff	{}	rigide, raide, crispé	\N	1	2018-07-18 04:55:15.050953+02
252	EN	garment	{}	vetement, habit	\N	1	2018-07-18 02:55:15.050953+02
251	EN	twilight	{}	crépuscule	\N	1	2018-07-18 00:55:15.050953+02
250	EN	fling	{}	lancer, passade	\N	1	2018-07-17 22:55:15.050953+02
249	EN	stout	{}	corpulent, fort	\N	1	2018-07-17 20:55:15.050953+02
248	EN	skimp	{}	mégoter, lésiner	\N	1	2018-07-17 18:55:15.050953+02
247	EN	pudgy	{}	enrobé, grassouillet	\N	1	2018-07-17 16:55:15.050953+02
246	EN	knoll	{}	monticule	\N	1	2018-07-17 14:55:15.050953+02
245	EN	flutter	{}	battre des ailes	\N	1	2018-07-17 12:55:15.050953+02
244	EN	cushion	{}	coussin	\N	1	2018-07-17 10:55:15.050953+02
243	EN	saliva	{}	salive	\N	1	2018-07-17 08:55:15.050953+02
242	EN	drool	{}	baver	\N	1	2018-07-17 06:55:15.050953+02
241	EN	swollen	{}	enflé, gonflé	\N	1	2018-07-17 04:55:15.050953+02
240	EN	bulge	{}	bosse, se gonfler	\N	1	2018-07-17 02:55:15.050953+02
239	EN	lawn	{}	gazon, pelouse	\N	1	2018-07-17 00:55:15.050953+02
238	EN	shingle	{}	galets	\N	1	2018-07-16 22:55:15.050953+02
237	EN	mound	{}	tas, pile	\N	1	2018-07-16 20:55:15.050953+02
236	EN	dump	{}	décharge publique	\N	1	2018-07-16 18:55:15.050953+02
235	EN	sprawl	{}	s'etendre, etre affalé, etre vautré	\N	1	2018-07-16 16:55:15.050953+02
234	EN	boulder	{}	énorme rocher	\N	1	2018-07-16 14:55:15.050953+02
233	EN	girder	{}	poutre	\N	1	2018-07-16 12:55:15.050953+02
232	EN	thrust	{}	pousser, imposer, enfoncer	\N	1	2018-07-16 10:55:15.050953+02
231	EN	rind	{}	écorce, couenne	\N	1	2018-07-16 08:55:15.050953+02
230	EN	hollow	{}	creux, vide	\N	1	2018-07-16 06:55:15.050953+02
229	EN	ore	{}	minerai	\N	1	2018-07-16 04:55:15.050953+02
228	EN	hare	{}	lièvre	\N	1	2018-07-16 02:55:15.050953+02
227	EN	loom	{}	se profiler	\N	1	2018-07-16 00:55:15.050953+02
226	EN	redeem	{}	racheter, échanger	\N	1	2018-07-15 22:55:15.050953+02
225	EN	abstruse	{}	obscur	\N	1	2018-07-15 20:55:15.050953+02
224	EN	hubris	{}	orgueil démesuré	\N	1	2018-07-15 18:55:15.050953+02
223	EN	wordWord	{}	wordDefinition	\N	1	2018-07-15 16:55:15.050953+02
215	EN	stir	{}	mélanger	\N	1	2018-07-15 14:55:15.050953+02
214	EN	pluck	{}	plumer, pincer, épiler	\N	1	2018-07-15 12:55:15.050953+02
213	EN	lift	{}	élever, se hisser	\N	1	2018-07-15 10:55:15.050953+02
212	EN	ilk	{}	genre, acabit	\N	1	2018-07-15 08:55:15.050953+02
211	EN	hog	{}	cochon (figuré)	\N	1	2018-07-15 06:55:15.050953+02
210	EN	peachy	{}	super, génial	\N	1	2018-07-15 04:55:15.050953+02
209	EN	whirl	{}	tourbillonner	\N	1	2018-07-15 02:55:15.050953+02
208	EN	beef up	{}	renforcer	\N	1	2018-07-15 00:55:15.050953+02
207	EN	abide	{}	ne pas supporter	\N	1	2018-07-14 22:55:15.050953+02
206	EN	wrought	{}	forgé, provoqué	\N	1	2018-07-14 20:55:15.050953+02
205	EN	right off the bat	{}	tout de suite	\N	1	2018-07-14 18:55:15.050953+02
204	EN	gee golly	{}	ca alors!	\N	1	2018-07-14 16:55:15.050953+02
203	EN	reap	{}	récolter les fruits	\N	1	2018-07-14 14:55:15.050953+02
202	EN	strive	{}	lutter	\N	1	2018-07-14 12:55:15.050953+02
201	EN	yardstick	{}	mètre	\N	1	2018-07-14 10:55:15.050953+02
200	EN	moot	{}	stérile (academic, no practical significance)	\N	1	2018-07-14 08:55:15.050953+02
199	EN	moot	{}	stérile	\N	1	2018-07-14 06:55:15.050953+02
198	EN	scourge	{}	fléau	\N	1	2018-07-14 04:55:15.050953+02
197	EN	cram	{}	entasser	\N	1	2018-07-14 02:55:15.050953+02
196	EN	comb	{}	peigne	\N	1	2018-07-14 00:55:15.050953+02
195	EN	nudge	{}	encourager, petit coup de coude	\N	1	2018-07-13 22:55:15.050953+02
194	EN	slain	{}	tuer, massacrer	\N	1	2018-07-13 20:55:15.050953+02
193	EN	interwoven	{}	entrelacé	\N	1	2018-07-13 18:55:15.050953+02
192	EN	sap	{}	enlever, retirer, nigaud	\N	1	2018-07-13 16:55:15.050953+02
191	EN	awash	{}	inondé	\N	1	2018-07-13 14:55:15.050953+02
190	EN	tongue-in-cheek	{}	ironique	\N	1	2018-07-13 12:55:15.050953+02
189	EN	shoe-horn	{}	chausse-pied	\N	1	2018-07-13 10:55:15.050953+02
188	EN	shoe-horn	{}	chausse-pied	\N	1	2018-07-13 08:55:15.050953+02
187	EN	convoluted	{}	alambiqué	\N	1	2018-07-13 06:55:15.050953+02
186	EN	mend	{}	raccomoder, réparer, repriser	\N	1	2018-07-13 04:55:15.050953+02
185	EN	hocus-pocus	{}	supercherie	\N	1	2018-07-13 02:55:15.050953+02
184	EN	meatier	{}	substantiel	\N	1	2018-07-13 00:55:15.050953+02
183	EN	out of the blue	{}	venu de nulle part	\N	1	2018-07-12 22:55:15.050953+02
182	EN	secular	{}	profane	\N	1	2018-07-12 20:55:15.050953+02
181	EN	murk	{}	obscurité	\N	1	2018-07-12 18:55:15.050953+02
180	EN	arrogate	{}	s'arroger, s'attribuer	\N	1	2018-07-12 16:55:15.050953+02
179	EN	uplift	{}	exalter, encourager	\N	1	2018-07-12 14:55:15.050953+02
178	EN	despise	{}	mépriser	\N	1	2018-07-12 12:55:15.050953+02
177	EN	bond	{}	liens	\N	1	2018-07-12 10:55:15.050953+02
176	EN	indictment	{}	inculpation	\N	1	2018-07-12 08:55:15.050953+02
175	EN	stroke	{}	coup (figuré, comme coup de main)	\N	1	2018-07-12 06:55:15.050953+02
174	EN	tug	{}	tirer sur	\N	1	2018-07-12 04:55:15.050953+02
173	EN	scurvy	{}	scorbut (manque de vitamine C)	\N	1	2018-07-12 02:55:15.050953+02
172	EN	to elide	{}	élider, omettre	\N	1	2018-07-12 00:55:15.050953+02
171	EN	to squawk	{}	crier	\N	1	2018-07-11 22:55:15.050953+02
170	EN	contrived	{}	contraint	\N	1	2018-07-11 20:55:15.050953+02
169	EN	swath	{}	envelopper	\N	1	2018-07-11 18:55:15.050953+02
168	PL	rower	{}	vélo	\N	1	2018-07-11 16:55:15.050953+02
167	EN	ruthless	{}	sans pitié	\N	1	2018-07-11 14:55:15.050953+02
166	EN	belittle	{}	rabaisser, dénigrer	\N	1	2018-07-11 12:55:15.050953+02
165	EN	compound	{}	mélange, aggraver	\N	1	2018-07-11 10:55:15.050953+02
164	EN	laudable	{}	louable	\N	1	2018-07-11 08:55:15.050953+02
163	EN	breed	{}	faire de l'élevage	\N	1	2018-07-11 06:55:15.050953+02
162	EN	gaze	{}	regard fixe	\N	1	2018-07-11 04:55:15.050953+02
161	EN	skulk	{}	roder	\N	1	2018-07-11 02:55:15.050953+02
160	EN	doth	{}	gond, charnière	\N	1	2018-07-11 00:55:15.050953+02
159	EN	hushed	{}	calme, feutré, étouffé	\N	1	2018-07-10 22:55:15.050953+02
158	EN	aback	{}	vers l'arrière	\N	1	2018-07-10 20:55:15.050953+02
157	EN	scathing	{}	très critique, cinglant	\N	1	2018-07-10 18:55:15.050953+02
156	EN	startle	{}	surprendre, étonner	\N	1	2018-07-10 16:55:15.050953+02
155	EN	bewildered	{}	perplexe	\N	1	2018-07-10 14:55:15.050953+02
154	EN	astute	{}	astucieux, malin	\N	1	2018-07-10 12:55:15.050953+02
153	EN	cattle	{}	bétail, veaux, mouton	\N	1	2018-07-10 10:55:15.050953+02
152	EN	hump	{}	bosse, le plus dur	\N	1	2018-07-10 08:55:15.050953+02
151	EN	trove	{}	trésor	\N	1	2018-07-10 06:55:15.050953+02
150	EN	stint	{}	période, séjour	\N	1	2018-07-10 04:55:15.050953+02
149	EN	henceforth	{}	dorénavant	\N	1	2018-07-10 02:55:15.050953+02
148	EN	blossom	{}	fleur, fleurir	\N	1	2018-07-10 00:55:15.050953+02
147	EN	ignited	{}	prendre feu, s'enflammer	\N	1	2018-07-09 22:55:15.050953+02
146	EN	shief	{}	liasse, gerbe	\N	1	2018-07-09 20:55:15.050953+02
145	EN	pore	{}	examiner	\N	1	2018-07-09 18:55:15.050953+02
144	EN	pacing	{}	allure	\N	1	2018-07-09 16:55:15.050953+02
143	EN	thorny	{}	épineux	\N	1	2018-07-09 14:55:15.050953+02
142	EN	forthright	{}	franc, direct	\N	1	2018-07-09 12:55:15.050953+02
141	EN	bolstered	{}	soutenir, renforcer	\N	1	2018-07-09 10:55:15.050953+02
140	EN	dawn	{}	aube, aurore	\N	1	2018-07-09 08:55:15.050953+02
139	EN	fathom	{}	comprendre, percer	\N	1	2018-07-09 06:55:15.050953+02
138	EN	starkly	{}	grandement	\N	1	2018-07-09 04:55:15.050953+02
137	EN	treacherous	{}	traitre	\N	1	2018-07-09 02:55:15.050953+02
136	EN	nook	{}	recoin	\N	1	2018-07-09 00:55:15.050953+02
135	EN	feisty	{}	agressif, fougeux	\N	1	2018-07-08 22:55:15.050953+02
134	EN	gather	{}	regrouper, cueillir	\N	1	2018-07-08 20:55:15.050953+02
133	EN	kitchen towel	{}	sopalin	\N	1	2018-07-08 18:55:15.050953+02
132	EN	top	{}	bouchon / capsule	\N	1	2018-07-08 16:55:15.050953+02
131	EN	cap	{}	bouchon / capsule	\N	1	2018-07-08 14:55:15.050953+02
130	EN	cap	{}	bouchon	\N	1	2018-07-08 12:55:15.050953+02
129	EN	plug	{}	bouchon	\N	1	2018-07-08 10:55:15.050953+02
128	EN	stopper	{}	bouchon	\N	1	2018-07-08 08:55:15.050953+02
127	EN	cork	{}	bouchon	\N	1	2018-07-08 06:55:15.050953+02
126	EN	top	{}	couvercle	\N	1	2018-07-08 04:55:15.050953+02
125	EN	cover	{}	couvercle	\N	1	2018-07-08 02:55:15.050953+02
124	EN	lid	{}	couvercle	\N	1	2018-07-08 00:55:15.050953+02
123	EN	shower head	{}	pommeau de douche	\N	1	2018-07-07 22:55:15.050953+02
122	EN	knob	{}	poignée	\N	1	2018-07-07 20:55:15.050953+02
121	EN	faucet	{}	robinet	\N	1	2018-07-07 18:55:15.050953+02
120	EN	tap	{}	robinet	\N	1	2018-07-07 16:55:15.050953+02
119	EN	sink	{}	évier	\N	1	2018-07-07 14:55:15.050953+02
118	EN	dishes	{}	vaisselle	\N	1	2018-07-07 12:55:15.050953+02
117	EN	blender	{}	mixeur	\N	1	2018-07-07 10:55:15.050953+02
116	EN	peeler	{}	économe / éplucheur	\N	1	2018-07-07 08:55:15.050953+02
115	EN	jar	{}	conserver (verre) / bocal	\N	1	2018-07-07 06:55:15.050953+02
114	EN	preserving jar	{}	bocal	\N	1	2018-07-07 04:55:15.050953+02
113	EN	can	{}	conserve (métal)	\N	1	2018-07-07 02:55:15.050953+02
112	EN	tin	{}	conserve (métal)	\N	1	2018-07-07 00:55:15.050953+02
111	EN	jar	{}	conserve (verre)	\N	1	2018-07-06 22:55:15.050953+02
110	EN	closet	{}	armoire	\N	1	2018-07-06 20:55:15.050953+02
109	EN	wardrobe	{}	armoire	\N	1	2018-07-06 18:55:15.050953+02
108	EN	chest of drawer	{}	commode	\N	1	2018-07-06 16:55:15.050953+02
107	EN	storage unit	{}	meuble de rangement	\N	1	2018-07-06 14:55:15.050953+02
106	EN	drawer	{}	tiroir	\N	1	2018-07-06 12:55:15.050953+02
105	EN	drainrack	{}	égouttoir	\N	1	2018-07-06 10:55:15.050953+02
104	EN	tea towel	{}	torchon	\N	1	2018-07-06 08:55:15.050953+02
103	EN	hood	{}	hotte	\N	1	2018-07-06 06:55:15.050953+02
102	EN	hotte	{}	hood cooker	\N	1	2018-07-06 04:55:15.050953+02
101	EN	ladle	{}	louche	\N	1	2018-07-06 02:55:15.050953+02
100	EN	oven	{}	four	\N	1	2018-07-06 00:55:15.050953+02
99	EN	pressure-cooker	{}	cocotte-minute	\N	1	2018-07-05 22:55:15.050953+02
96	EN	cabinet	{}	armoire	\N	1	2018-07-05 20:55:15.050953+02
95	EN	wardrobe	{}	armoire	\N	1	2018-07-05 18:55:15.050953+02
94	EN	leeway	{}	marge	\N	1	2018-07-05 16:55:15.050953+02
93	EN	tusk	{}	défense d'animal	\N	1	2018-07-05 14:55:15.050953+02
92	EN	lather	{}	savonner	\N	1	2018-07-05 12:55:15.050953+02
91	EN	inane	{}	inepte, stupide	\N	1	2018-07-05 10:55:15.050953+02
90	EN	hindsight	{}	avoir du recul	\N	1	2018-07-05 08:55:15.050953+02
89	EN	trough	{}	désespoir	\N	1	2018-07-05 06:55:15.050953+02
88	EN	opine	{}	faire remarquer	\N	1	2018-07-05 04:55:15.050953+02
87	EN	panacea	{}	panacée (cure for everything)	\N	1	2018-07-05 02:55:15.050953+02
86	EN	pesky	{}	fichu, sale, embettant	\N	1	2018-07-05 00:55:15.050953+02
85	EN	perk	{}	avantage	\N	1	2018-07-04 22:55:15.050953+02
84	EN	demanding	{}	exigeant	\N	1	2018-07-04 20:55:15.050953+02
83	EN	hitchhiker	{}	auto stoppeur	\N	1	2018-07-04 18:55:15.050953+02
82	EN	incentive	{}	motivation	\N	1	2018-07-04 16:55:15.050953+02
81	EN	dwindle	{}	diminuer/baisser	\N	1	2018-07-04 14:55:15.050953+02
80	EN	brink	{}	(figuré) bord	\N	1	2018-07-04 12:55:15.050953+02
79	EN	eavesdropping	{}	ecouter aux portes	\N	1	2018-07-04 10:55:15.050953+02
78	EN	halve	{}	reduire de moitie	\N	1	2018-07-04 08:55:15.050953+02
77	PL	kobieta	{}	femme	\N	1	2018-07-04 06:55:15.050953+02
76	EN	glimmer	{}	faible lueur	\N	1	2018-07-04 04:55:15.050953+02
75	EN	phase out	{}	expression - mettre un terme	\N	1	2018-07-04 02:55:15.050953+02
74	EN	lampoon	{}	ridiculiser	\N	1	2018-07-04 00:55:15.050953+02
73	EN	stymied	{}	contrecarrer / faire obstable a	\N	1	2018-07-03 22:55:15.050953+02
72	EN	whack	{}	donner un grand coup a / donner une claque a	\N	1	2018-07-03 20:55:15.050953+02
71	EN	curtailed	{}	ecourter	\N	1	2018-07-03 18:55:15.050953+02
70	EN	wager	{}	(un) pari	\N	1	2018-07-03 16:55:15.050953+02
69	EN	strife	{}	querelle	\N	1	2018-07-03 14:55:15.050953+02
68	EN	stride	{}	pas	\N	1	2018-07-03 12:55:15.050953+02
67	EN	albeit	{}	bien que	\N	1	2018-07-03 10:55:15.050953+02
66	EN	vernacular	{}	jargon	\N	1	2018-07-03 08:55:15.050953+02
65	EN	mince	{}	haché	\N	1	2018-07-03 06:55:15.050953+02
64	EN	veneer	{}	vernis / apparence	\N	1	2018-07-03 04:55:15.050953+02
63	EN	leek	{}	poireau	\N	1	2018-07-03 02:55:15.050953+02
62	EN	barley	{}	orge	\N	1	2018-07-03 00:55:15.050953+02
61	EN	groat	{}	gruaut	\N	1	2018-07-02 22:55:15.050953+02
60	EN	harness	{}	maitriser exploiter	\N	1	2018-07-02 20:55:15.050953+02
59	EN	convoluted (twisted)	{}	tordu	\N	1	2018-07-02 18:55:15.050953+02
58	EN	confound	{}	perturber	\N	1	2018-07-02 16:55:15.050953+02
57	EN	wreck	{}	accident / vieille voiture / tacot	\N	1	2018-07-02 14:55:15.050953+02
56	EN	wart	{}	verrue	\N	1	2018-07-02 12:55:15.050953+02
55	EN	compelling	{}	irrefutable	\N	1	2018-07-02 10:55:15.050953+02
54	EN	foster	{}	promouvoir encourager	\N	1	2018-07-02 08:55:15.050953+02
53	EN	stewardship	{}	intendance administration	\N	1	2018-07-02 06:55:15.050953+02
52	EN	to despise	{}	mépriser	\N	1	2018-07-02 04:55:15.050953+02
51	FR	canonique	{}	conforme a une regle	\N	1	2018-07-02 02:55:15.050953+02
50	EN	mind you	{}	expression - bien entendu	\N	1	2018-07-02 00:55:15.050953+02
49	EN	wisdom	{}	sagesse / bon sens	\N	1	2018-07-01 22:55:15.050953+02
48	EN	at odds	{}	expression - en desaccord	\N	1	2018-07-01 20:55:15.050953+02
47	EN	kick in the teeth	{}	expression - coup bas.	\N	1	2018-07-01 18:55:15.050953+02
46	EN	pernicious	{}	pernicieux / malveillant	\N	1	2018-07-01 16:55:15.050953+02
45	EN	schlepping	{}	(familier) se trimballer	\N	1	2018-07-01 14:55:15.050953+02
44	EN	creep	{}	grimper / ramper / se glisser	\N	1	2018-07-01 12:55:15.050953+02
43	EN	(to) Impede	{}	to retard in movement or progress by means of obstacles or hindrances;	\N	1	2018-07-01 10:55:15.050953+02
42	EN	cogent	{}	convaincant / preuve	\N	1	2018-07-01 08:55:15.050953+02
41	EN	quagmire	{}	bourbier	\N	1	2018-07-01 06:55:15.050953+02
40	FR	exsuder	{}	évaporation	\N	1	2018-07-01 04:55:15.050953+02
39	EN	cogent	{}	convaincant / preuve	\N	1	2018-07-01 02:55:15.050953+02
38	EN	quagmire	{}	bourbier	\N	1	2018-07-01 00:55:15.050953+02
37	EN	slogging	{}	trimmer, travailler dur	\N	1	2018-06-30 22:55:15.050953+02
36	EN	daunting	{}	intimidant	\N	1	2018-06-30 20:55:15.050953+02
35	EN	cog	{}	roue dentée	\N	1	2018-06-30 18:55:15.050953+02
34	EN	quibble	{}	critique	\N	1	2018-06-30 16:55:15.050953+02
33	EN	brass	{}	cuivre	\N	1	2018-06-30 14:55:15.050953+02
32	EN	twitch	{}	avoir un mouvement convulsif	\N	1	2018-06-30 12:55:15.050953+02
31	EN	wand	{}	baguette magique	\N	1	2018-06-30 10:55:15.050953+02
30	EN	thrust	{}	pousser, forcer, imposer	\N	1	2018-06-30 08:55:15.050953+02
29	EN	fiddly	{}	minutieux, délicat	\N	1	2018-06-30 06:55:15.050953+02
28	EN	dismay	{}	désarroi, consterner	\N	1	2018-06-30 04:55:15.050953+02
27	EN	grasp	{}	saisir, comprendre	\N	1	2018-06-30 02:55:15.050953+02
26	EN	fringe	{}	banlieue, marge	\N	1	2018-06-30 00:55:15.050953+02
25	EN	prying	{}	indiscret	\N	1	2018-06-29 22:55:15.050953+02
24	EN	eschew	{}	éviter, fuir	\N	1	2018-06-29 20:55:15.050953+02
23	EN	ubiquitous	{}	omniprésent	\N	1	2018-06-29 18:55:15.050953+02
22	EN	clameur	{}	réclamer	\N	1	2018-06-29 16:55:15.050953+02
21	EN	casualty	{}	blessé, mort	\N	1	2018-06-29 14:55:15.050953+02
20	EN	apathetic	{}	apathique, indifférent	\N	1	2018-06-29 12:55:15.050953+02
19	EN	wrestle	{}	luter	\N	1	2018-06-29 10:55:15.050953+02
18	EN	trite	{}	banal	\N	1	2018-06-29 08:55:15.050953+02
17	EN	incur	{}	encourir	\N	1	2018-06-29 06:55:15.050953+02
315	EN	limp1	{}	mou, molle	5	1	2018-07-22 12:55:15.050953+02
385	EN	to conceal (sth)	{}	dissimuler, cacher	\N	1	2018-07-28 08:55:15.050953+02
384	EN	dreary	{}	morne, gris	\N	1	2018-07-28 06:55:15.050953+02
383	EN	whispered to do (sth)	{}	il se murmure que..., on dit que...	\N	1	2018-07-28 04:55:15.050953+02
381	EN	enamored of (sth)	{}	passionne de	\N	1	2018-07-28 00:55:15.050953+02
380	EN	worn	{}	use, erode	\N	1	2018-07-27 22:55:15.050953+02
378	EN	uncanny	{}	mysterieux, etrange	\N	1	2018-07-27 18:55:15.050953+02
377	EN	furnace	{}	fourneau, chaudiere, fournaise	\N	1	2018-07-27 16:55:15.050953+02
376	EN	to botch	{}	foirer, rater, bacler	\N	1	2018-07-27 14:55:15.050953+02
375	EN	to bulge	{}	se gonfler, ressortir, bomber	\N	1	2018-07-27 12:55:15.050953+02
374	EN	drawl	{}	voix trainante	\N	1	2018-07-27 10:55:15.050953+02
373	EN	damp	{}	humide	\N	1	2018-07-27 08:55:15.050953+02
372	EN	feeble	{}	faible, febrile	\N	1	2018-07-27 06:55:15.050953+02
371	EN	to grate (sth)	{}	raper	\N	1	2018-07-27 04:55:15.050953+02
370	EN	to grate	{}	grincer, crisser	\N	1	2018-07-27 02:55:15.050953+02
369	EN	to loathe (sb/sth)	{}	detester, hair, execrer	\N	1	2018-07-27 00:55:15.050953+02
368	EN	shingle	{}	galets, graviers	\N	1	2018-07-26 22:55:15.050953+02
367	EN	to astound (sb)	{}	stupefier, etonner	\N	1	2018-07-26 20:55:15.050953+02
366	EN	unkempt	{}	neglige, peu soigne	\N	1	2018-07-26 18:55:15.050953+02
365	EN	frieze	{}	frise	\N	1	2018-07-26 16:55:15.050953+02
364	EN	to flaunt	{}	exhiber, montrer, etaler	\N	1	2018-07-26 14:55:15.050953+02
363	EN	to startle (sb/sth)	{}	surprendre, etonner, faire sursauter	\N	1	2018-07-26 12:55:15.050953+02
362	EN	to aspire to (sth)	{}	aspirer a	\N	1	2018-07-26 10:55:15.050953+02
361	EN	seldom	{}	rarement	\N	1	2018-07-26 08:55:15.050953+02
360	EN	blotch	{}	tache	\N	1	2018-07-26 06:55:15.050953+02
359	EN	streak	{}	trace, marque, trainee	\N	1	2018-07-26 04:55:15.050953+02
358	EN	to boast	{}	se vanter, fanfaronner	\N	1	2018-07-26 02:55:15.050953+02
357	EN	to smear	{}	etaler, mettre	\N	1	2018-07-26 00:55:15.050953+02
356	EN	smear	{}	tache, trace	\N	1	2018-07-25 22:55:15.050953+02
354	EN	to flare	{}	eclater, s'echauffer	\N	1	2018-07-25 18:55:15.050953+02
353	EN	tenement	{}	immeuble	\N	1	2018-07-25 16:55:15.050953+02
352	EN	grim	{}	sombre	\N	1	2018-07-25 14:55:15.050953+02
351	EN	to bow to (sb)	{}	faire une reverence, s'incliner	\N	1	2018-07-25 12:55:15.050953+02
350	EN	lint	{}	peluche, charpie	\N	1	2018-07-25 10:55:15.050953+02
349	EN	to jot (sth) on (sth)	{}	noter (qqchse) sur (qqchse)	\N	1	2018-07-25 08:55:15.050953+02
348	EN	a jot of (sth)	{}	un brin de, un iota de	\N	1	2018-07-25 06:55:15.050953+02
347	EN	realtor	{}	agent immobilier	\N	1	2018-07-25 04:55:15.050953+02
346	EN	blatant	{}	flagrant	\N	1	2018-07-25 02:55:15.050953+02
345	EN	to smudge	{}	tacher, etaler	\N	1	2018-07-25 00:55:15.050953+02
344	EN	smudge	{}	tache, bavure	\N	1	2018-07-24 22:55:15.050953+02
343	EN	to quail	{}	trembler, tressaillir	\N	1	2018-07-24 20:55:15.050953+02
342	EN	to sag	{}	s'affaisser, tomber, pendre	\N	1	2018-07-24 18:55:15.050953+02
341	EN	swarm	{}	essaim, colonie, masse	\N	1	2018-07-24 16:55:15.050953+02
340	EN	to splinter	{}	se briser en eclat	\N	1	2018-07-24 14:55:15.050953+02
339	EN	splinter	{}	echarde, esquille	\N	1	2018-07-24 12:55:15.050953+02
338	EN	rustle	{}	bruissement, froissement	\N	1	2018-07-24 10:55:15.050953+02
337	EN	to soil	{}	salir, souiller	\N	1	2018-07-24 08:55:15.050953+02
336	EN	soil	{}	sol, terre	\N	1	2018-07-24 06:55:15.050953+02
335	EN	to flunk	{}	rater, ne pas avoir	\N	1	2018-07-24 04:55:15.050953+02
334	EN	to recede	{}	reculer, s'eloigner, s'estomper, disparaitre	\N	1	2018-07-24 02:55:15.050953+02
333	EN	wart	{}	verrue	\N	1	2018-07-24 00:55:15.050953+02
332	EN	sallow	{}	cireux, cireuse	\N	1	2018-07-23 22:55:15.050953+02
331	EN	to wrinkle	{}	plisser, froisser	\N	1	2018-07-23 20:55:15.050953+02
330	EN	wrinkle	{}	ride	\N	1	2018-07-23 18:55:15.050953+02
329	EN	to shimmer	{}	chatoyer, scintiller, miroiter	\N	1	2018-07-23 16:55:15.050953+02
328	EN	to jerk (sth)	{}	tirer d'un coup sec, faire un mouvement brusque	\N	1	2018-07-23 14:55:15.050953+02
327	EN	to thrust (sth) on (sb)	{}	imposer	\N	1	2018-07-23 12:55:15.050953+02
326	EN	to thrust (sth/sb)	{}	pousser	\N	1	2018-07-23 10:55:15.050953+02
325	EN	rod	{}	tige, canne, coup de baton	\N	1	2018-07-23 08:55:15.050953+02
324	EN	to convey (sth)	{}	communiquer, transmettre, faire part	\N	1	2018-07-23 06:55:15.050953+02
323	EN	slender	{}	mince, svelte, gracile	\N	1	2018-07-23 04:55:15.050953+02
322	EN	gilt	{}	dorure, dore	\N	1	2018-07-23 02:55:15.050953+02
321	EN	to decree	{}	decreter, ordonner	\N	1	2018-07-23 00:55:15.050953+02
320	EN	fling	{}	passade, amourette	\N	1	2018-07-22 22:55:15.050953+02
319	EN	to fling yourself	{}	se jeter, se precipiter	\N	1	2018-07-22 20:55:15.050953+02
318	EN	to fling	{}	lancer	\N	1	2018-07-22 18:55:15.050953+02
317	EN	to fluster	{}	troubler, agiter	\N	1	2018-07-22 16:55:15.050953+02
316	EN	jiffy	{}	instant, seconde, minute	\N	1	2018-07-22 14:55:15.050953+02
314	EN	to limp	{}	boiter	\N	1	2018-07-22 10:55:15.050953+02
313	EN	to shudder	{}	trembler, fremir	\N	1	2018-07-22 08:55:15.050953+02
312	EN	annuity	{}	rente, viager	\N	1	2018-07-22 06:55:15.050953+02
311	EN	untangle	{}	demeler	\N	1	2018-07-22 04:55:15.050953+02
400	EN	to crib	{}	copier, pomper	\N	1	2018-07-29 14:55:15.050953+02
399	EN	crib	{enfant,famille,personne}	berceau	\N	1	2018-07-29 12:55:15.050953+02
398	EN	as it ought to be	{}	ce qu'il devrait etre	\N	1	2018-07-29 10:55:15.050953+02
397	EN	to chime	{}	sonner (les cloches)	\N	1	2018-07-29 08:55:15.050953+02
396	EN	chime	{}	carillon	\N	1	2018-07-29 06:55:15.050953+02
395	EN	to deem	{}	juger, estimer, considerer	\N	1	2018-07-29 04:55:15.050953+02
394	EN	comprise (sth)	{}	constituer, representer, former	\N	1	2018-07-29 02:55:15.050953+02
393	EN	reluctantly	{}	a contre-coeur, avec reticence	\N	1	2018-07-29 00:55:15.050953+02
392	EN	liability	{}	handicap, frein, boulet	\N	1	2018-07-28 22:55:15.050953+02
391	EN	snappy	{}	vif, energique	\N	1	2018-07-28 20:55:15.050953+02
390	EN	demeaning	{}	degrandant, devalorisant	\N	1	2018-07-28 18:55:15.050953+02
389	EN	save, save for	{}	sauf	\N	1	2018-07-28 16:55:15.050953+02
388	EN	to utter (sth)	{}	prononcer, dire, pousser, proferer	\N	1	2018-07-28 14:55:15.050953+02
387	EN	rung	{}	barreau, echelon	\N	1	2018-07-28 12:55:15.050953+02
386	EN	to loll	{}	se prelasser, faineanter, pendre, tomber	\N	1	2018-07-28 10:55:15.050953+02
310	EN	gown	{}	robe de chambre, peignoir	\N	1	2018-07-22 02:55:15.050953+02
309	EN	to roar	{}	rugir, hurler	\N	1	2018-07-22 00:55:15.050953+02
308	EN	to trim	{}	couper, tailler	\N	1	2018-07-21 22:55:15.050953+02
307	EN	slender	{}	mince, svelte	\N	1	2018-07-21 20:55:15.050953+02
306	EN	to reel	{}	enrouler, bobiner	\N	1	2018-07-21 18:55:15.050953+02
305	EN	to shiver	{}	trembler, frissoner	\N	1	2018-07-21 16:55:15.050953+02
304	EN	garland	{}	guirlande	\N	1	2018-07-21 14:55:15.050953+02
303	EN	flourish	{}	prosperer	\N	1	2018-07-21 12:55:15.050953+02
302	EN	custodian	{}	gardien, conservateur	\N	1	2018-07-21 10:55:15.050953+02
301	EN	limestone	{}	calcaire	\N	1	2018-07-21 08:55:15.050953+02
300	EN	puddle	{}	flaque d'eau	\N	1	2018-07-21 06:55:15.050953+02
299	EN	wince	{}	grimacer	\N	1	2018-07-21 04:55:15.050953+02
298	EN	forestall	{}	prevenir	\N	1	2018-07-21 02:55:15.050953+02
297	EN	shack	{}	cabane, cahute, case	\N	1	2018-07-21 00:55:15.050953+02
296	EN	beam	{}	rayon de lumiere, rayon, poutre	\N	1	2018-07-20 22:55:15.050953+02
295	EN	earnest	{}	serieux, serieuse	\N	1	2018-07-20 20:55:15.050953+02
294	EN	deed	{}	acte, action	\N	1	2018-07-20 18:55:15.050953+02
293	EN	to bear	{}	supporter	\N	1	2018-07-20 16:55:15.050953+02
292	EN	stunt	{}	cascade, coup de pub, combine	\N	1	2018-07-20 14:55:15.050953+02
291	EN	sheer	{}	pur, simple, extra-fin	\N	1	2018-07-20 12:55:15.050953+02
290	EN	wellfare	{}	bien-etre, allocation	\N	1	2018-07-20 10:55:15.050953+02
289	EN	plea	{}	appel, defense, excuse	\N	1	2018-07-20 08:55:15.050953+02
288	EN	entwined	{}	entrelacer, lier	\N	1	2018-07-20 06:55:15.050953+02
277	EN	spurious	{}	faux	\N	1	2018-07-20 04:55:15.050953+02
276	EN	peculiar	{}	étrange, bizarre	\N	1	2018-07-20 02:55:15.050953+02
275	EN	tout	{}	raccoler	\N	1	2018-07-20 00:55:15.050953+02
274	EN	seasoned	{}	expérimenté	\N	1	2018-07-19 22:55:15.050953+02
273	EN	circumscribe	{}	délimiter	\N	1	2018-07-19 20:55:15.050953+02
272	EN	womb	{}	utérus	\N	1	2018-07-19 18:55:15.050953+02
271	EN	weightless	{}	en apesanteur	\N	1	2018-07-19 16:55:15.050953+02
270	EN	dismay	{}	désarroi	\N	1	2018-07-19 14:55:15.050953+02
269	EN	linger	{}	s'attarder	\N	1	2018-07-19 12:55:15.050953+02
268	EN	gist	{}	idée générale	\N	1	2018-07-19 10:55:15.050953+02
267	EN	one-off	{}	quelque chose d'exceptionnel	\N	1	2018-07-19 08:55:15.050953+02
266	EN	one-off	{}	quelque chose	\N	1	2018-07-19 06:55:15.050953+02
265	EN	garner	{}	recueillir, récolter	\N	1	2018-07-19 04:55:15.050953+02
264	EN	hinge	{}	gond, charnière	\N	1	2018-07-19 02:55:15.050953+02
263	EN	strife	{}	querelle	\N	1	2018-07-19 00:55:15.050953+02
262	EN	midst	{}	au milieu de	\N	1	2018-07-18 22:55:15.050953+02
261	EN	remit	{}	attribution	\N	1	2018-07-18 20:55:15.050953+02
16	EN	stiff	{}	rigide	\N	1	2018-06-29 04:55:15.050953+02
15	EN	crackle	{}	crépiter	\N	1	2018-06-29 02:55:15.050953+02
14	EN	distress	{}	bouleverser	\N	1	2018-06-29 00:55:15.050953+02
13	EN	net	{}	filet	\N	1	2018-06-28 22:55:15.050953+02
12	EN	swerve	{}	faire un écart	\N	1	2018-06-28 20:55:15.050953+02
11	EN	dart	{}	foncer, se précipiter	\N	1	2018-06-28 18:55:15.050953+02
10	EN	edible	{}	mangeable, comestible	\N	1	2018-06-28 16:55:15.050953+02
9	EN	shire	{}	comté	\N	1	2018-06-28 14:55:15.050953+02
8	EN	nudge	{}	petit coup de coude	\N	1	2018-06-28 12:55:15.050953+02
7	EN	delineate	{}	définir	\N	1	2018-06-28 10:55:15.050953+02
6	EN	averse	{}	éprouver de la répugnance pour	\N	1	2018-06-28 08:55:15.050953+02
5	EN	fraught	{}	stressant, tendu	\N	1	2018-06-28 06:55:15.050953+02
4	EN	womb	{}	uterus, ventre	\N	1	2018-06-28 04:55:15.050953+02
3	EN	allowance	{}	argent de poche	\N	1	2018-06-28 02:55:15.050953+02
2	EN	transfixed	{}	subjugué, captivé	\N	1	2018-06-28 00:55:15.050953+02
1	EN	slogging	{}	trimmer, travailler dur	\N	1	2018-06-27 22:55:15.050953+02
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
-- Name: token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: arkadefr
--

SELECT pg_catalog.setval('public.token_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: arkadefr
--

SELECT pg_catalog.setval('public.users_id_seq', 37, true);


--
-- Name: words_id_seq; Type: SEQUENCE SET; Schema: public; Owner: arkadefr
--

SELECT pg_catalog.setval('public.words_id_seq', 411, true);


--
-- Name: token token_pkey; Type: CONSTRAINT; Schema: public; Owner: arkadefr
--

ALTER TABLE ONLY public.token
    ADD CONSTRAINT token_pkey PRIMARY KEY (id);


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

