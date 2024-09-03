SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: pg_search_dmetaphone(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.pg_search_dmetaphone(text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT array_to_string(ARRAY(SELECT dmetaphone(unnest(regexp_split_to_array($1, E'\\s+')))), ' ') $_$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notes (
    id bigint NOT NULL,
    text text,
    work_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notes_id_seq OWNED BY public.notes.id;


--
-- Name: producers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.producers (
    id bigint NOT NULL,
    custom_name character varying,
    given_name character varying,
    middle_name character varying,
    family_name character varying,
    foreign_name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    birth_year integer,
    death_year integer,
    bio_link character varying,
    nationality character varying,
    works_count integer DEFAULT 0,
    searchable tsvector GENERATED ALWAYS AS ((((setweight(to_tsvector('english'::regconfig, (COALESCE(custom_name, ''::character varying))::text), 'A'::"char") || setweight(to_tsvector('english'::regconfig, (COALESCE(given_name, ''::character varying))::text), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(family_name, ''::character varying))::text), 'C'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(foreign_name, ''::character varying))::text), 'D'::"char"))) STORED
);


--
-- Name: producers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.producers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: producers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.producers_id_seq OWNED BY public.producers.id;


--
-- Name: publishers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.publishers (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    works_count integer DEFAULT 0
);


--
-- Name: publishers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.publishers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: publishers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.publishers_id_seq OWNED BY public.publishers.id;


--
-- Name: quotes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quotes (
    id bigint NOT NULL,
    text text,
    page character varying,
    custom_citation character varying,
    work_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    searchable tsvector GENERATED ALWAYS AS (setweight(to_tsvector('english'::regconfig, COALESCE(text, ''::text)), 'A'::"char")) STORED
);


--
-- Name: quotes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quotes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quotes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quotes_id_seq OWNED BY public.quotes.id;


--
-- Name: reading_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reading_sessions (
    id bigint NOT NULL,
    started_at timestamp(6) without time zone,
    ended_at timestamp(6) without time zone,
    work_id bigint NOT NULL,
    pages integer,
    duration integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: reading_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reading_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reading_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reading_sessions_id_seq OWNED BY public.reading_sessions.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: work_producers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.work_producers (
    id bigint NOT NULL,
    work_id bigint NOT NULL,
    producer_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    role integer
);


--
-- Name: work_producers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.work_producers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: work_producers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.work_producers_id_seq OWNED BY public.work_producers.id;


--
-- Name: works; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.works (
    id bigint NOT NULL,
    title character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    publisher_id bigint,
    subtitle character varying,
    alternate_title character varying,
    foreign_title character varying,
    year_of_composition integer,
    year_of_publication integer,
    language character varying,
    original_language character varying,
    tags character varying[] DEFAULT '{}'::character varying[],
    searchable tsvector GENERATED ALWAYS AS (setweight(to_tsvector('english'::regconfig, (COALESCE(title, ''::character varying))::text), 'A'::"char")) STORED,
    rating integer,
    format integer DEFAULT 0,
    custom_citation character varying,
    parent_id integer
);


--
-- Name: works_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.works_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: works_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.works_id_seq OWNED BY public.works.id;


--
-- Name: notes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes ALTER COLUMN id SET DEFAULT nextval('public.notes_id_seq'::regclass);


--
-- Name: producers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.producers ALTER COLUMN id SET DEFAULT nextval('public.producers_id_seq'::regclass);


--
-- Name: publishers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publishers ALTER COLUMN id SET DEFAULT nextval('public.publishers_id_seq'::regclass);


--
-- Name: quotes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quotes ALTER COLUMN id SET DEFAULT nextval('public.quotes_id_seq'::regclass);


--
-- Name: reading_sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reading_sessions ALTER COLUMN id SET DEFAULT nextval('public.reading_sessions_id_seq'::regclass);


--
-- Name: work_producers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_producers ALTER COLUMN id SET DEFAULT nextval('public.work_producers_id_seq'::regclass);


--
-- Name: works id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.works ALTER COLUMN id SET DEFAULT nextval('public.works_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: notes notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: producers producers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.producers
    ADD CONSTRAINT producers_pkey PRIMARY KEY (id);


--
-- Name: publishers publishers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publishers
    ADD CONSTRAINT publishers_pkey PRIMARY KEY (id);


--
-- Name: quotes quotes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quotes
    ADD CONSTRAINT quotes_pkey PRIMARY KEY (id);


--
-- Name: reading_sessions reading_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reading_sessions
    ADD CONSTRAINT reading_sessions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: work_producers work_producers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_producers
    ADD CONSTRAINT work_producers_pkey PRIMARY KEY (id);


--
-- Name: works works_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.works
    ADD CONSTRAINT works_pkey PRIMARY KEY (id);


--
-- Name: index_notes_on_work_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_work_id ON public.notes USING btree (work_id);


--
-- Name: index_producers_on_searchable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_producers_on_searchable ON public.producers USING gin (searchable);


--
-- Name: index_quotes_on_searchable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_quotes_on_searchable ON public.quotes USING gin (searchable);


--
-- Name: index_quotes_on_work_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_quotes_on_work_id ON public.quotes USING btree (work_id);


--
-- Name: index_reading_sessions_on_work_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reading_sessions_on_work_id ON public.reading_sessions USING btree (work_id);


--
-- Name: index_work_producers_on_producer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_work_producers_on_producer_id ON public.work_producers USING btree (producer_id);


--
-- Name: index_work_producers_on_work_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_work_producers_on_work_id ON public.work_producers USING btree (work_id);


--
-- Name: index_work_producers_on_work_id_and_producer_id_and_role; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_work_producers_on_work_id_and_producer_id_and_role ON public.work_producers USING btree (work_id, producer_id, role);


--
-- Name: index_works_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_works_on_parent_id ON public.works USING btree (parent_id);


--
-- Name: index_works_on_publisher_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_works_on_publisher_id ON public.works USING btree (publisher_id);


--
-- Name: index_works_on_searchable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_works_on_searchable ON public.works USING gin (searchable);


--
-- Name: index_works_on_tags; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_works_on_tags ON public.works USING gin (tags);


--
-- Name: reading_sessions fk_rails_0de1d5975c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reading_sessions
    ADD CONSTRAINT fk_rails_0de1d5975c FOREIGN KEY (work_id) REFERENCES public.works(id);


--
-- Name: work_producers fk_rails_2cc1957f2c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_producers
    ADD CONSTRAINT fk_rails_2cc1957f2c FOREIGN KEY (work_id) REFERENCES public.works(id);


--
-- Name: works fk_rails_2f1aaa4674; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.works
    ADD CONSTRAINT fk_rails_2f1aaa4674 FOREIGN KEY (publisher_id) REFERENCES public.publishers(id);


--
-- Name: quotes fk_rails_5aa8a1f152; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quotes
    ADD CONSTRAINT fk_rails_5aa8a1f152 FOREIGN KEY (work_id) REFERENCES public.works(id);


--
-- Name: work_producers fk_rails_70482c1ff8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_producers
    ADD CONSTRAINT fk_rails_70482c1ff8 FOREIGN KEY (producer_id) REFERENCES public.producers(id);


--
-- Name: notes fk_rails_9fa473ac93; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT fk_rails_9fa473ac93 FOREIGN KEY (work_id) REFERENCES public.works(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20240903162335'),
('20240831205129'),
('20240823201941'),
('20240821205656'),
('20240821200516'),
('20240821181310'),
('20240821030845'),
('20240820231558'),
('20240815004339'),
('20240814232714'),
('20240813213517'),
('20240813212558'),
('20240811224747'),
('20240809193141'),
('20240809174729'),
('20240809173244'),
('20240808000221'),
('20240807223430'),
('20240807215038'),
('20240807195442'),
('20240806223144'),
('20240802214946'),
('20240731171116'),
('20240731170953'),
('20240731170927');

