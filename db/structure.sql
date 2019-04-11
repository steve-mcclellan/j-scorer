SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

-- commented out due to Heroku shenanigans:
-- COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: category_topics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.category_topics (
    id integer NOT NULL,
    category_type character varying,
    category_id integer,
    topic_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: category_topics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.category_topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: category_topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.category_topics_id_seq OWNED BY public.category_topics.id;


--
-- Name: finals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.finals (
    id integer NOT NULL,
    game_id integer,
    category_title character varying,
    result integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    topics_string character varying,
    first_right boolean,
    second_right boolean,
    third_right boolean
);


--
-- Name: finals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.finals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: finals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.finals_id_seq OWNED BY public.finals.id;


--
-- Name: games; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.games (
    id integer NOT NULL,
    user_id integer,
    show_date date,
    date_played timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    play_type character varying DEFAULT 'regular'::character varying,
    round_one_score integer,
    round_two_score integer,
    final_result integer,
    dd1_result integer,
    dd2a_result integer,
    dd2b_result integer,
    rerun boolean DEFAULT false NOT NULL,
    game_id character varying NOT NULL
);


--
-- Name: games_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.games_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: games_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.games_id_seq OWNED BY public.games.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sixths; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sixths (
    id integer NOT NULL,
    game_id integer,
    type character varying,
    board_position integer,
    title character varying,
    result1 integer DEFAULT 0,
    result2 integer DEFAULT 0,
    result3 integer DEFAULT 0,
    result4 integer DEFAULT 0,
    result5 integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    topics_string character varying
);


--
-- Name: sixths_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sixths_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sixths_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sixths_id_seq OWNED BY public.sixths.id;


--
-- Name: topics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.topics (
    id integer NOT NULL,
    user_id integer,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: topics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.topics_id_seq OWNED BY public.topics.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    password_digest character varying,
    remember_digest character varying,
    reset_digest character varying,
    reset_sent_at timestamp without time zone,
    play_types character varying[] DEFAULT '{regular}'::character varying[],
    show_date_reverse boolean,
    show_date_preposition character varying(10),
    show_date_beginning date,
    show_date_last_number integer,
    show_date_last_unit character varying(1),
    show_date_from date,
    show_date_to date,
    show_date_weight character varying(10),
    show_date_half_life double precision,
    date_played_reverse boolean,
    date_played_preposition character varying(10),
    date_played_beginning date,
    date_played_last_number integer,
    date_played_last_unit character varying(1),
    date_played_from date,
    date_played_to date,
    date_played_weight character varying(10),
    date_played_half_life double precision,
    rerun_status integer DEFAULT 0 NOT NULL
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
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category_topics ALTER COLUMN id SET DEFAULT nextval('public.category_topics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.finals ALTER COLUMN id SET DEFAULT nextval('public.finals_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.games ALTER COLUMN id SET DEFAULT nextval('public.games_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sixths ALTER COLUMN id SET DEFAULT nextval('public.sixths_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topics ALTER COLUMN id SET DEFAULT nextval('public.topics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: category_topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category_topics
    ADD CONSTRAINT category_topics_pkey PRIMARY KEY (id);


--
-- Name: finals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.finals
    ADD CONSTRAINT finals_pkey PRIMARY KEY (id);


--
-- Name: games_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.games
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sixths_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sixths
    ADD CONSTRAINT sixths_pkey PRIMARY KEY (id);


--
-- Name: topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_category_topics_on_category_type_and_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_category_topics_on_category_type_and_category_id ON public.category_topics USING btree (category_type, category_id);


--
-- Name: index_category_topics_on_topic_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_category_topics_on_topic_id ON public.category_topics USING btree (topic_id);


--
-- Name: index_category_topics_to_assure_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_category_topics_to_assure_uniqueness ON public.category_topics USING btree (topic_id, category_id, category_type);


--
-- Name: index_finals_on_game_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_finals_on_game_id ON public.finals USING btree (game_id);


--
-- Name: index_games_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_games_on_user_id ON public.games USING btree (user_id);


--
-- Name: index_games_on_user_id_and_date_played; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_games_on_user_id_and_date_played ON public.games USING btree (user_id, date_played);


--
-- Name: index_games_on_user_id_and_game_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_games_on_user_id_and_game_id ON public.games USING btree (user_id, game_id);


--
-- Name: index_games_on_user_id_and_play_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_games_on_user_id_and_play_type ON public.games USING btree (user_id, play_type);


--
-- Name: index_games_on_user_id_and_rerun; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_games_on_user_id_and_rerun ON public.games USING btree (user_id, rerun);


--
-- Name: index_games_on_user_id_and_show_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_games_on_user_id_and_show_date ON public.games USING btree (user_id, show_date);


--
-- Name: index_sixths_on_game_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sixths_on_game_id ON public.sixths USING btree (game_id);


--
-- Name: index_topics_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_topics_on_user_id ON public.topics USING btree (user_id);


--
-- Name: index_topics_on_user_id_and_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_topics_on_user_id_and_name ON public.topics USING btree (user_id, name);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: fk_rails_064f1dadb9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category_topics
    ADD CONSTRAINT fk_rails_064f1dadb9 FOREIGN KEY (topic_id) REFERENCES public.topics(id);


--
-- Name: fk_rails_7b812cfb44; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT fk_rails_7b812cfb44 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fk_rails_de9e6ea7f7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.games
    ADD CONSTRAINT fk_rails_de9e6ea7f7 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fk_rails_debebe87e0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.finals
    ADD CONSTRAINT fk_rails_debebe87e0 FOREIGN KEY (game_id) REFERENCES public.games(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20160507203334'),
('20160507212032'),
('20160507212809'),
('20160508154744'),
('20160509215159'),
('20160510211659'),
('20160510212934'),
('20160512183448'),
('20160512191708'),
('20160512192635'),
('20160512193040'),
('20160512193858'),
('20160512194133'),
('20160512195133'),
('20160513120011'),
('20160601141915'),
('20160601144446'),
('20160601170600'),
('20160601170801'),
('20160601194120'),
('20160601194627'),
('20160601194754'),
('20160623193817'),
('20160701212322'),
('20160701212342'),
('20160703132507'),
('20160705211103'),
('20160709133813'),
('20161031155918'),
('20161116170851'),
('20161116205246'),
('20161116222030'),
('20170909161948'),
('20170909163110'),
('20170909163655'),
('20170909171911'),
('20170924191436'),
('20171029185801'),
('20180902143604');


