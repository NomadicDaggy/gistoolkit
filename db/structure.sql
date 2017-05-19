--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


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
-- Name: cemeteries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE cemeteries (
    id integer NOT NULL,
    geom geometry(Polygon,4326),
    name character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    address character varying,
    phone_number character varying,
    city character varying,
    region character varying,
    geo_ratio numeric(20,16)
);


--
-- Name: cemeteries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cemeteries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cemeteries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cemeteries_id_seq OWNED BY cemeteries.id;


--
-- Name: points; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE points (
    id integer NOT NULL,
    cemetery_id integer NOT NULL,
    kind character varying,
    geom geometry(Point,4326),
    diameter double precision DEFAULT 0.0,
    label character varying DEFAULT ''::character varying
);


--
-- Name: other_points_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE other_points_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: other_points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE other_points_id_seq OWNED BY points.id;


--
-- Name: plots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE plots (
    id integer NOT NULL,
    cemetery_id integer NOT NULL,
    geom geometry(Polygon,4326),
    label character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: plots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE plots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE plots_id_seq OWNED BY plots.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sectors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sectors (
    id integer NOT NULL,
    cemetery_id integer NOT NULL,
    geom geometry(Polygon,4326),
    label character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sectors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sectors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sectors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sectors_id_seq OWNED BY sectors.id;


--
-- Name: streets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE streets (
    id integer NOT NULL,
    cemetery_id integer NOT NULL,
    kind character varying,
    geom geometry(MultiLineString,4326)
);


--
-- Name: streets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE streets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: streets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE streets_id_seq OWNED BY streets.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying,
    email character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    password_digest character varying,
    remember_digest character varying,
    admin boolean DEFAULT false,
    reset_digest character varying,
    reset_sent_at timestamp without time zone
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
-- Name: cemeteries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cemeteries ALTER COLUMN id SET DEFAULT nextval('cemeteries_id_seq'::regclass);


--
-- Name: plots id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY plots ALTER COLUMN id SET DEFAULT nextval('plots_id_seq'::regclass);


--
-- Name: points id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY points ALTER COLUMN id SET DEFAULT nextval('other_points_id_seq'::regclass);


--
-- Name: sectors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sectors ALTER COLUMN id SET DEFAULT nextval('sectors_id_seq'::regclass);


--
-- Name: streets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY streets ALTER COLUMN id SET DEFAULT nextval('streets_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: cemeteries cemeteries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cemeteries
    ADD CONSTRAINT cemeteries_pkey PRIMARY KEY (id);


--
-- Name: points other_points_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY points
    ADD CONSTRAINT other_points_pkey PRIMARY KEY (id);


--
-- Name: plots plots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY plots
    ADD CONSTRAINT plots_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sectors sectors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sectors
    ADD CONSTRAINT sectors_pkey PRIMARY KEY (id);


--
-- Name: streets streets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY streets
    ADD CONSTRAINT streets_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_cemeteries_on_geom; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cemeteries_on_geom ON cemeteries USING gist (geom);


--
-- Name: index_other_points_on_cemetery_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_other_points_on_cemetery_id ON points USING btree (cemetery_id);


--
-- Name: index_other_points_on_geom; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_other_points_on_geom ON points USING gist (geom);


--
-- Name: index_plots_on_cemetery_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_plots_on_cemetery_id ON plots USING btree (cemetery_id);


--
-- Name: index_plots_on_geom; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_plots_on_geom ON plots USING gist (geom);


--
-- Name: index_sectors_on_cemetery_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sectors_on_cemetery_id ON sectors USING btree (cemetery_id);


--
-- Name: index_sectors_on_geom; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sectors_on_geom ON sectors USING gist (geom);


--
-- Name: index_streets_on_cemetery_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_streets_on_cemetery_id ON streets USING btree (cemetery_id);


--
-- Name: index_streets_on_geom; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_streets_on_geom ON streets USING gist (geom);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES
('20170117104031'),
('20170117112249'),
('20170117113212'),
('20170117161409'),
('20170118114822'),
('20170121154431'),
('20170417102121'),
('20170426164547'),
('20170507120407'),
('20170519102143'),
('20170519104505'),
('20170519104522');


