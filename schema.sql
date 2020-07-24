--------------------------------------------------------------------------------
-- PostgreSQL database
--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------
-- SCHEMA
--------------------------------------------------------------------------------

CREATE SCHEMA ng03;
ALTER SCHEMA ng03 OWNER TO exileng;

--------------------------------------------------------------------------------
-- FUNCTIONS
--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_create(_user_id integer, _remote_addr character varying, _user_agent character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   test record;

   profile_id integer;

BEGIN

   SELECT INTO test * FROM gm_profiles WHERE user_id = _user_id;
   IF FOUND THEN RETURN -1; END IF;

   INSERT INTO gm_profiles(user_id) VALUES(_user_id) RETURNING id INTO profile_id;

   INSERT INTO log_connections(profile_id, remote_addr, user_agent) VALUES(profile_id, _remote_addr, _user_agent);

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_create(_user_id integer, _remote_addr character varying, _user_agent character varying) OWNER TO exileng;

--------------------------------------------------------------------------------
-- TABLES
--------------------------------------------------------------------------------

SET default_tablespace = '';
SET default_table_access_method = heap;

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_profiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_profiles_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_profiles (
    id integer NOT NULL,
    user_id integer NOT NULL,
    privilege character varying DEFAULT 'new'::character varying NOT NULL,
    reset_count smallint DEFAULT 0 NOT NULL,
    bankruptcy smallint DEFAULT 168 NOT NULL
);

ALTER TABLE ng03.gm_profiles OWNER TO exileng;

ALTER SEQUENCE ng03.gm_profiles_id_seq OWNED BY ng03.gm_profiles.id;

ALTER TABLE ONLY ng03.gm_profiles ALTER COLUMN id SET DEFAULT nextval('ng03.gm_profiles_id_seq'::regclass);

ALTER TABLE ONLY ng03.gm_profiles ADD CONSTRAINT gm_profiles_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_profiles ADD CONSTRAINT gm_profiles_user_id_key UNIQUE (user_id);
ALTER TABLE ONLY ng03.gm_profiles ADD CONSTRAINT gm_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.auth_user(id) ON UPDATE CASCADE ON DELETE CASCADE;

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.log_connections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.log_connections_id_seq OWNER TO exileng;

CREATE TABLE ng03.log_connections (
    id integer NOT NULL,
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    profile_id integer NOT NULL,
    remote_addr character varying NOT NULL,
    user_agent character varying NOT NULL
);

ALTER TABLE ng03.log_connections OWNER TO exileng;

ALTER SEQUENCE ng03.log_connections_id_seq OWNED BY ng03.log_connections.id;

ALTER TABLE ONLY ng03.log_connections ALTER COLUMN id SET DEFAULT nextval('ng03.log_connections_id_seq'::regclass);

ALTER TABLE ONLY ng03.log_connections ADD CONSTRAINT log_connections_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.log_connections ADD CONSTRAINT log_connections_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;

--------------------------------------------------------------------------------
-- VALUES
--------------------------------------------------------------------------------

INSERT INTO ng03.gm_profiles VALUES (1, 350, 'new', 0, 168);

--------------------------------------------------------------------------------

INSERT INTO ng03.log_connections VALUES (1, '2020-07-24 12:03:04.090402+00', 1, '176.174.9.154', 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36');

--------------------------------------------------------------------------------
-- PostgreSQL database
--------------------------------------------------------------------------------
