--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.8
-- Dumped by pg_dump version 9.5.8

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
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

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: tablefunc; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS tablefunc WITH SCHEMA public;


--
-- Name: EXTENSION tablefunc; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION tablefunc IS 'functions that manipulate whole tables, including crosstab';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: category_topics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE category_topics (
    id integer NOT NULL,
    category_id integer,
    category_type character varying,
    topic_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: category_topics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE category_topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: category_topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE category_topics_id_seq OWNED BY category_topics.id;


--
-- Name: finals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE finals (
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

CREATE SEQUENCE finals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: finals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE finals_id_seq OWNED BY finals.id;


--
-- Name: games; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE games (
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
    rerun boolean DEFAULT false NOT NULL
);


--
-- Name: games_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE games_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: games_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE games_id_seq OWNED BY games.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sixths; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sixths (
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

CREATE SEQUENCE sixths_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sixths_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sixths_id_seq OWNED BY sixths.id;


--
-- Name: topics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE topics (
    id integer NOT NULL,
    user_id integer,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: topics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE topics_id_seq OWNED BY topics.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    password_digest character varying,
    remember_digest character varying,
    reset_digest character varying,
    reset_sent_at timestamp without time zone,
    play_types character varying[] DEFAULT '{regular}'::character varying[]
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY category_topics ALTER COLUMN id SET DEFAULT nextval('category_topics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY finals ALTER COLUMN id SET DEFAULT nextval('finals_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY games ALTER COLUMN id SET DEFAULT nextval('games_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sixths ALTER COLUMN id SET DEFAULT nextval('sixths_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY topics ALTER COLUMN id SET DEFAULT nextval('topics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: category_topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY category_topics
    ADD CONSTRAINT category_topics_pkey PRIMARY KEY (id);


--
-- Name: finals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY finals
    ADD CONSTRAINT finals_pkey PRIMARY KEY (id);


--
-- Name: games_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);


--
-- Name: sixths_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sixths
    ADD CONSTRAINT sixths_pkey PRIMARY KEY (id);


--
-- Name: topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_category_topics_on_category_type_and_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_category_topics_on_category_type_and_category_id ON category_topics USING btree (category_type, category_id);


--
-- Name: index_category_topics_on_topic_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_category_topics_on_topic_id ON category_topics USING btree (topic_id);


--
-- Name: index_category_topics_to_assure_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_category_topics_to_assure_uniqueness ON category_topics USING btree (topic_id, category_id, category_type);


--
-- Name: index_finals_on_game_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_finals_on_game_id ON finals USING btree (game_id);


--
-- Name: index_games_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_games_on_user_id ON games USING btree (user_id);


--
-- Name: index_games_on_user_id_and_date_played; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_games_on_user_id_and_date_played ON games USING btree (user_id, date_played);


--
-- Name: index_games_on_user_id_and_play_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_games_on_user_id_and_play_type ON games USING btree (user_id, play_type);


--
-- Name: index_games_on_user_id_and_rerun; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_games_on_user_id_and_rerun ON games USING btree (user_id, rerun);


--
-- Name: index_games_on_user_id_and_show_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_games_on_user_id_and_show_date ON games USING btree (user_id, show_date);


--
-- Name: index_sixths_on_game_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sixths_on_game_id ON sixths USING btree (game_id);


--
-- Name: index_topics_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_topics_on_user_id ON topics USING btree (user_id);


--
-- Name: index_topics_on_user_id_and_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_topics_on_user_id_and_name ON topics USING btree (user_id, name);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_064f1dadb9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY category_topics
    ADD CONSTRAINT fk_rails_064f1dadb9 FOREIGN KEY (topic_id) REFERENCES topics(id);


--
-- Name: fk_rails_7b812cfb44; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY topics
    ADD CONSTRAINT fk_rails_7b812cfb44 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_de9e6ea7f7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY games
    ADD CONSTRAINT fk_rails_de9e6ea7f7 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_debebe87e0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY finals
    ADD CONSTRAINT fk_rails_debebe87e0 FOREIGN KEY (game_id) REFERENCES games(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES
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
('20170909163655');


