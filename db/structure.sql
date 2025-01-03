SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- Name: work_producer_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.work_producer_role AS ENUM (
    'author',
    'editor',
    'contributor',
    'translator',
    'illustrator'
);


--
-- Name: work_publishing_format; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.work_publishing_format AS ENUM (
    'book',
    'chapter',
    'ebook',
    'journal_article',
    'news_article',
    'book_review',
    'interview',
    'thesis',
    'web_page',
    'social_media',
    'video',
    'personal'
);


--
-- Name: pg_search_dmetaphone(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.pg_search_dmetaphone(text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT array_to_string(ARRAY(SELECT dmetaphone(unnest(regexp_split_to_array($1, E'\s+')))), ' ') $_$;


--
-- Name: unaccented_dict; Type: TEXT SEARCH CONFIGURATION; Schema: public; Owner: -
--

CREATE TEXT SEARCH CONFIGURATION public.unaccented_dict (
    PARSER = pg_catalog."default" );

ALTER TEXT SEARCH CONFIGURATION public.unaccented_dict
    ADD MAPPING FOR asciiword WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccented_dict
    ADD MAPPING FOR word WITH public.unaccent, simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccented_dict
    ADD MAPPING FOR numword WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccented_dict
    ADD MAPPING FOR email WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccented_dict
    ADD MAPPING FOR url WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccented_dict
    ADD MAPPING FOR host WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccented_dict
    ADD MAPPING FOR sfloat WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccented_dict
    ADD MAPPING FOR version WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccented_dict
    ADD MAPPING FOR hword_numpart WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccented_dict
    ADD MAPPING FOR hword_part WITH public.unaccent, simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccented_dict
    ADD MAPPING FOR hword_asciipart WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccented_dict
    ADD MAPPING FOR numhword WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccented_dict
    ADD MAPPING FOR asciihword WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccented_dict
    ADD MAPPING FOR hword WITH public.unaccent, simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccented_dict
    ADD MAPPING FOR url_path WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccented_dict
    ADD MAPPING FOR file WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccented_dict
    ADD MAPPING FOR "float" WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccented_dict
    ADD MAPPING FOR "int" WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccented_dict
    ADD MAPPING FOR uint WITH simple;


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
-- Name: flipper_features; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flipper_features (
    id bigint NOT NULL,
    key character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: flipper_features_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.flipper_features_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: flipper_features_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.flipper_features_id_seq OWNED BY public.flipper_features.id;


--
-- Name: flipper_gates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flipper_gates (
    id bigint NOT NULL,
    feature_key character varying NOT NULL,
    key character varying NOT NULL,
    value text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: flipper_gates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.flipper_gates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: flipper_gates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.flipper_gates_id_seq OWNED BY public.flipper_gates.id;


--
-- Name: notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notes (
    id bigint NOT NULL,
    text text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    notable_type character varying NOT NULL,
    notable_id bigint NOT NULL
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
    forename character varying,
    middle_name character varying,
    surname character varying,
    foreign_name character varying,
    bio_link character varying,
    nationality character varying,
    year_of_birth integer,
    year_of_death integer,
    works_count integer DEFAULT 0,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    searchable tsvector GENERATED ALWAYS AS ((((setweight(to_tsvector('public.unaccented_dict'::regconfig, (COALESCE(custom_name, ''::character varying))::text), 'A'::"char") || setweight(to_tsvector('public.unaccented_dict'::regconfig, (COALESCE(forename, ''::character varying))::text), 'B'::"char")) || setweight(to_tsvector('public.unaccented_dict'::regconfig, (COALESCE(surname, ''::character varying))::text), 'C'::"char")) || setweight(to_tsvector('public.unaccented_dict'::regconfig, (COALESCE(foreign_name, ''::character varying))::text), 'D'::"char"))) STORED
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
    works_count integer DEFAULT 0,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    location character varying,
    CONSTRAINT publishers_name_presence CHECK (((name IS NOT NULL) AND ((name)::text !~ '^\s*$'::text)))
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
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    remember_created_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: work_producers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.work_producers (
    id bigint NOT NULL,
    work_id bigint NOT NULL,
    producer_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    role public.work_producer_role DEFAULT 'author'::public.work_producer_role
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
    subtitle character varying,
    supertitle character varying,
    alternate_title character varying,
    foreign_title character varying,
    custom_citation character varying,
    accession_note text,
    tags character varying[] DEFAULT '{}'::character varying[],
    language character varying,
    original_language character varying,
    parent_id bigint,
    rating integer,
    year_of_composition integer,
    year_of_publication integer,
    date_of_completion date,
    date_of_accession date,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    publishing_format public.work_publishing_format DEFAULT 'book'::public.work_publishing_format,
    publisher_id bigint,
    searchable tsvector GENERATED ALWAYS AS ((((setweight(to_tsvector('public.unaccented_dict'::regconfig, (COALESCE(title, ''::character varying))::text), 'A'::"char") || setweight(to_tsvector('public.unaccented_dict'::regconfig, (COALESCE(subtitle, ''::character varying))::text), 'B'::"char")) || setweight(to_tsvector('public.unaccented_dict'::regconfig, (COALESCE(supertitle, ''::character varying))::text), 'C'::"char")) || setweight(to_tsvector('public.unaccented_dict'::regconfig, (COALESCE(foreign_title, ''::character varying))::text), 'D'::"char"))) STORED,
    online_source character varying,
    url character varying,
    journal_name character varying,
    journal_volume integer,
    journal_issue integer,
    article_page_span character varying,
    article_date date,
    review_title character varying,
    review_author character varying,
    media_source character varying,
    media_timestamp character varying,
    interviewer_name character varying,
    media_format character varying,
    media_date date,
    wishlist boolean DEFAULT false,
    condition integer,
    cover integer,
    series_ordinal integer
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
-- Name: flipper_features id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flipper_features ALTER COLUMN id SET DEFAULT nextval('public.flipper_features_id_seq'::regclass);


--
-- Name: flipper_gates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flipper_gates ALTER COLUMN id SET DEFAULT nextval('public.flipper_gates_id_seq'::regclass);


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
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


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
-- Name: flipper_features flipper_features_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flipper_features
    ADD CONSTRAINT flipper_features_pkey PRIMARY KEY (id);


--
-- Name: flipper_gates flipper_gates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flipper_gates
    ADD CONSTRAINT flipper_gates_pkey PRIMARY KEY (id);


--
-- Name: notes notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: producers producers_forename_surname_year_of_birth_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.producers
    ADD CONSTRAINT producers_forename_surname_year_of_birth_unique UNIQUE (forename, surname, year_of_birth) DEFERRABLE;


--
-- Name: producers producers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.producers
    ADD CONSTRAINT producers_pkey PRIMARY KEY (id);


--
-- Name: publishers publishers_name_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publishers
    ADD CONSTRAINT publishers_name_unique UNIQUE (name) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: work_producers work_producers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_producers
    ADD CONSTRAINT work_producers_pkey PRIMARY KEY (id);


--
-- Name: work_producers work_producers_work_id_producer_id_role_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_producers
    ADD CONSTRAINT work_producers_work_id_producer_id_role_unique UNIQUE (work_id, producer_id, role) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: works works_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.works
    ADD CONSTRAINT works_pkey PRIMARY KEY (id);


--
-- Name: index_flipper_features_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_flipper_features_on_key ON public.flipper_features USING btree (key);


--
-- Name: index_flipper_gates_on_feature_key_and_key_and_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_flipper_gates_on_feature_key_and_key_and_value ON public.flipper_gates USING btree (feature_key, key, value);


--
-- Name: index_notes_on_notable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_notable ON public.notes USING btree (notable_type, notable_id);


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
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_work_producers_on_producer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_work_producers_on_producer_id ON public.work_producers USING btree (producer_id);


--
-- Name: index_work_producers_on_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_work_producers_on_role ON public.work_producers USING btree (role);


--
-- Name: index_work_producers_on_work_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_work_producers_on_work_id ON public.work_producers USING btree (work_id);


--
-- Name: index_works_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_works_on_parent_id ON public.works USING btree (parent_id);


--
-- Name: index_works_on_publisher_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_works_on_publisher_id ON public.works USING btree (publisher_id);


--
-- Name: index_works_on_publishing_format; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_works_on_publishing_format ON public.works USING btree (publishing_format);


--
-- Name: index_works_on_searchable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_works_on_searchable ON public.works USING gin (searchable);


--
-- Name: index_works_on_tags; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_works_on_tags ON public.works USING gin (tags);


--
-- Name: index_works_on_wishlist; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_works_on_wishlist ON public.works USING btree (wishlist);


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
-- Name: works fk_rails_f55f563ef0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.works
    ADD CONSTRAINT fk_rails_f55f563ef0 FOREIGN KEY (parent_id) REFERENCES public.works(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20241025192411'),
('20241016190110'),
('20241015205125'),
('20241011192903'),
('20241002230402'),
('20240924183914'),
('20240924000304'),
('20240919181412'),
('20240823201941'),
('20240815004339'),
('20240813213517'),
('20240811224747'),
('20240806223144'),
('20240731171116'),
('20240731170953'),
('20240731170927'),
('20240731170926');

