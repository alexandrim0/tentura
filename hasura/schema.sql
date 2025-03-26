--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: beacon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.beacon (
    id text DEFAULT concat('B', "substring"((gen_random_uuid())::text, '\w{12}'::text)) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    user_id text NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    timerange tstzrange,
    enabled boolean DEFAULT true NOT NULL,
    has_picture boolean DEFAULT false NOT NULL,
    lat double precision,
    long double precision,
    context text,
    pic_height integer DEFAULT 0 NOT NULL,
    pic_width integer DEFAULT 0 NOT NULL,
    blur_hash text DEFAULT ''::text NOT NULL,
    ticker integer DEFAULT 0 NOT NULL,
    CONSTRAINT beacon__description_len CHECK ((char_length(description) <= 2048)),
    CONSTRAINT beacon__title_len CHECK ((char_length(title) <= 128)),
    CONSTRAINT beacon_context_name_length CHECK (((char_length(context) >= 3) AND (char_length(context) <= 32)))
);


ALTER TABLE public.beacon OWNER TO postgres;

--
-- Name: beacon_get_is_pinned(public.beacon, json); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.beacon_get_is_pinned(beacon_row public.beacon, hasura_session json) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$

SELECT COALESCE(

(SELECT true AS "is_pinned" FROM beacon_pinned WHERE

  user_id = (hasura_session ->> 'x-hasura-user-id')::TEXT AND beacon_id = beacon_row.id),

  false);

$$;


ALTER FUNCTION public.beacon_get_is_pinned(beacon_row public.beacon, hasura_session json) OWNER TO postgres;

--
-- Name: beacon_get_my_vote(public.beacon, json); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.beacon_get_my_vote(beacon_row public.beacon, hasura_session json) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT COALESCE((SELECT amount FROM vote_beacon WHERE subject = (hasura_session ->> 'x-hasura-user-id')::TEXT AND object = beacon_row.id), 0);
$$;


ALTER FUNCTION public.beacon_get_my_vote(beacon_row public.beacon, hasura_session json) OWNER TO postgres;

--
-- Name: mutual_score; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.mutual_score AS
 SELECT ''::text AS src,
    ''::text AS dst,
    (0)::double precision AS src_score,
    (0)::double precision AS dst_score
  WHERE false;


ALTER VIEW public.mutual_score OWNER TO postgres;

--
-- Name: beacon_get_scores(public.beacon, json); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.beacon_get_scores(beacon_row public.beacon, hasura_session json) RETURNS SETOF public.mutual_score
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT
  src,
  dst,
  score_cluster_of_src AS src_score,
  score_cluster_of_dst AS dst_score
FROM mr_node_score(
  hasura_session ->> 'x-hasura-user-id',
  beacon_row.id,
  hasura_session ->> 'x-hasura-query-context'
);
$$;


ALTER FUNCTION public.beacon_get_scores(beacon_row public.beacon, hasura_session json) OWNER TO postgres;

--
-- Name: comment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comment (
    id text DEFAULT concat('C', "substring"((gen_random_uuid())::text, '\w{12}'::text)) NOT NULL,
    user_id text NOT NULL,
    content text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    beacon_id text NOT NULL,
    ticker integer DEFAULT 0 NOT NULL,
    CONSTRAINT comment_content_length CHECK (((char_length(content) > 0) AND (char_length(content) <= 2048)))
);


ALTER TABLE public.comment OWNER TO postgres;

--
-- Name: comment_get_my_vote(public.comment, json); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.comment_get_my_vote(comment_row public.comment, hasura_session json) RETURNS integer
    LANGUAGE sql STABLE
    AS $$

  SELECT COALESCE((SELECT amount FROM vote_comment WHERE subject = (hasura_session ->> 'x-hasura-user-id')::TEXT AND object = comment_row.id), 0);

$$;


ALTER FUNCTION public.comment_get_my_vote(comment_row public.comment, hasura_session json) OWNER TO postgres;

--
-- Name: comment_get_scores(public.comment, json); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.comment_get_scores(comment_row public.comment, hasura_session json) RETURNS SETOF public.mutual_score
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT
  src,
  dst,
  score_cluster_of_src AS src_score,
  score_cluster_of_dst AS dst_score
FROM mr_node_score(
    hasura_session ->> 'x-hasura-user-id',
    comment_row.id,
    hasura_session ->> 'x-hasura-query-context'
    
);
$$;


ALTER FUNCTION public.comment_get_scores(comment_row public.comment, hasura_session json) OWNER TO postgres;

--
-- Name: graph(text, text, boolean, json); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.graph(focus text, context text, positive_only boolean, hasura_session json) RETURNS SETOF public.mutual_score
    LANGUAGE sql STABLE
    AS $$
SELECT
  src,
  dst,
  score_cluster_of_ego AS src_score,
  score_cluster_of_dst AS dst_score
FROM
  mr_graph(
    hasura_session ->> 'x-hasura-user-id',
    focus,
    context,
    positive_only,
    0,
    100
  );
$$;


ALTER FUNCTION public.graph(focus text, context text, positive_only boolean, hasura_session json) OWNER TO postgres;

--
-- Name: meritrank_init(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.meritrank_init() RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
  _count integer := 0;
  _total integer := 0;
  _beacon record;
  _comment record;
  _opinion record;
BEGIN
  -- Edges User -> User (vote)
  SELECT count(*) INTO STRICT _count FROM (
    SELECT mr_put_edge(edge.src, edge.dst, edge.amount, '', edge.ticker) FROM (
      SELECT vote_user.subject AS src,
        vote_user.object AS dst,
        vote_user.amount AS amount,
        vote_user.ticker
      FROM vote_user
    ) AS edge);
  _total := _total + _count;

  -- Edges Author <-> Beacon
  FOR _beacon IN SELECT id, user_id, context, ticker FROM "beacon" LOOP
    -- Beacon -> Author
    PERFORM mr_put_edge(_beacon.id, _beacon.user_id, 1, _beacon.context, 0);
    -- Author -> Beacon
    PERFORM mr_put_edge(_beacon.user_id, _beacon.id, 1, _beacon.context, _beacon.ticker);
    _total := _total + 2;
  END LOOP;

  -- Edges User -> Beacon (vote)
  SELECT count(*) INTO STRICT _count FROM (
    SELECT mr_put_edge(edge.src, edge.dst, edge.amount, edge.context, edge.ticker) FROM (
      SELECT vote_beacon.subject AS src,
        vote_beacon.object AS dst,
        vote_beacon.amount AS amount,
        beacon.context AS context,
        vote_beacon.ticker
      FROM vote_beacon JOIN beacon ON beacon.id = vote_beacon.object
    ) AS edge);
  _total := _total + _count;

  -- Edges Author <-> Comment
  FOR _comment IN SELECT "comment".id, "comment".user_id, context, "comment".ticker FROM "comment" JOIN "beacon" ON "comment".beacon_id = "beacon".id LOOP
    -- Comment -> Author
    PERFORM mr_put_edge(_comment.id, _comment.user_id, 1, _comment.context, 0);
    -- Author -> Comment
    PERFORM mr_put_edge(_comment.user_id, _comment.id, 1, _comment.context, _comment.ticker);
    _total := _total + 2;
  END LOOP;

  -- Edges User -> Comment (vote)
  SELECT count(*) INTO STRICT _count FROM (
    SELECT mr_put_edge(edge.src, edge.dst, edge.amount, edge.context, edge.ticker) FROM (
      SELECT vote_comment.subject AS src,
        vote_comment.object AS dst,
        vote_comment.amount AS amount,
        beacon.context AS context,
        vote_comment.ticker
      FROM vote_comment JOIN "comment" ON "comment".id = vote_comment.object JOIN beacon ON beacon.id = "comment".beacon_id
    ) AS edge);
  _total := _total + _count;

  -- Edges for Opinion
  FOR _opinion IN SELECT id, subject, object, amount, ticker FROM "opinion" LOOP
    -- Author -> Opinion
    PERFORM mr_put_edge(_opinion.subject, _opinion.id, (abs(_opinion.amount))::double precision, '', _opinion.ticker);
    -- Opinion -> Author
    PERFORM mr_put_edge(_opinion.id, _opinion.subject, (1)::double precision, '', _opinion.ticker);
    -- Opinion -> User
    PERFORM mr_put_edge(_opinion.id, _opinion.object, (sign(_opinion.amount))::double precision, '', _opinion.ticker);
    _total := _total + 3;
  END LOOP;

  -- Read Updates Filters
  SELECT count(*) INTO STRICT _count FROM (
    SELECT mr_set_new_edges_filter(user_id, filter) FROM user_updates
  );
  _total := _total + _count;

  RETURN _total;
END;
$$;


ALTER FUNCTION public.meritrank_init() OWNER TO postgres;

--
-- Name: my_field(text, json); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.my_field(context text, hasura_session json) RETURNS SETOF public.mutual_score
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT
  src,
  dst,
  score_cluster_of_src AS src_score,
  score_cluster_of_dst AS dst_score
FROM
  mr_scores(
    hasura_session ->> 'x-hasura-user-id',
    true,
    context,
    'B',
    null,
    null,
    '0',
    null,
    0,
    100
  );
$$;


ALTER FUNCTION public.my_field(context text, hasura_session json) OWNER TO postgres;

--
-- Name: notify_meritrank_beacon_mutation(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_meritrank_beacon_mutation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    _counter integer;
BEGIN
    IF (TG_OP = 'INSERT') THEN
        UPDATE user_vsids SET counter = counter + 1 WHERE user_id = NEW.user_id RETURNING counter INTO _counter;
        PERFORM mr_put_edge(NEW.id, NEW.user_id, 1::double precision, NEW.context, 0);
        PERFORM mr_put_edge(NEW.user_id, NEW.id, 1::double precision, NEW.context, _counter);
        NEW.ticker = _counter;
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        PERFORM mr_delete_edge(OLD.id, OLD.user_id, OLD.context);
        PERFORM mr_delete_edge(OLD.user_id, OLD.id, OLD.context);
        RETURN OLD;
    END IF;
END;
$$;


ALTER FUNCTION public.notify_meritrank_beacon_mutation() OWNER TO postgres;

--
-- Name: notify_meritrank_comment_mutation(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_meritrank_comment_mutation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    context text;
    _counter integer;
BEGIN
    SELECT beacon.context INTO context FROM beacon WHERE beacon.id = NEW.beacon_id;
    IF (TG_OP = 'INSERT') THEN
        UPDATE user_vsids SET counter = counter + 1 WHERE user_id = NEW.user_id RETURNING counter INTO _counter;
        PERFORM mr_put_edge(NEW.id, NEW.user_id, 1::double precision, context, 0);
        PERFORM mr_put_edge(NEW.user_id, NEW.id, 1::double precision, context, _counter);
        NEW.ticker = _counter;
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        PERFORM mr_delete_edge(OLD.id, OLD.user_id, context);
        PERFORM mr_delete_edge(OLD.user_id, OLD.id, context);
        RETURN OLD;
    END IF;
END;
$$;


ALTER FUNCTION public.notify_meritrank_comment_mutation() OWNER TO postgres;

--
-- Name: notify_meritrank_opinion_mutation(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_meritrank_opinion_mutation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    _counter integer;
BEGIN
  IF (TG_OP = 'INSERT') THEN
    UPDATE user_vsids SET counter = counter + 1 WHERE user_id = NEW.subject RETURNING counter INTO _counter;
    PERFORM mr_put_edge(NEW.subject, NEW.id, (abs(NEW.amount))::double precision, '', _counter);
    PERFORM mr_put_edge(NEW.id, NEW.subject, (1)::double precision, '', _counter);
    PERFORM mr_put_edge(NEW.id, NEW.object, (sign(NEW.amount))::double precision, '', _counter);
    NEW.ticker = _counter;
    RETURN NEW;
  ELSIF (TG_OP = 'DELETE') THEN
    PERFORM mr_delete_edge(OLD.subject, OLD.id);
    PERFORM mr_delete_edge(OLD.id, OLD.subject);
    PERFORM mr_delete_edge(OLD.id, OLD.object);
    RETURN OLD;
  END IF;
END;
$$;


ALTER FUNCTION public.notify_meritrank_opinion_mutation() OWNER TO postgres;

--
-- Name: notify_meritrank_vote_beacon_mutation(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_meritrank_vote_beacon_mutation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    context text;
    _counter integer;
BEGIN
    SELECT beacon.context INTO STRICT context FROM beacon WHERE beacon.id = NEW.object;
    IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
        UPDATE user_vsids SET counter = counter + 1 WHERE user_id = NEW.subject RETURNING counter INTO _counter;
        PERFORM mr_put_edge(NEW.subject, NEW.object, (NEW.amount)::double precision, context, _counter);
        NEW.ticker = _counter;
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        PERFORM mr_delete_edge(OLD.subject, OLD.object, context);
        RETURN OLD;
    END IF;
END;
$$;


ALTER FUNCTION public.notify_meritrank_vote_beacon_mutation() OWNER TO postgres;

--
-- Name: notify_meritrank_vote_comment_mutation(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_meritrank_vote_comment_mutation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    context text;
    beacon_id text;
    _counter integer;
BEGIN
    SELECT comment.beacon_id INTO beacon_id FROM comment WHERE comment.id = NEW.object;
    SELECT beacon.context INTO context FROM beacon WHERE beacon.id = beacon_id;
    IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
        UPDATE user_vsids SET counter = counter + 1 WHERE user_id = NEW.subject RETURNING counter INTO _counter;
        PERFORM mr_put_edge(NEW.subject, NEW.object, (NEW.amount)::double precision, context, _counter);
        NEW.ticker = _counter;
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        PERFORM mr_delete_edge(OLD.subject, OLD.object, context);
        RETURN OLD;
    END IF;
END;
$$;


ALTER FUNCTION public.notify_meritrank_vote_comment_mutation() OWNER TO postgres;

--
-- Name: notify_meritrank_vote_user_mutation(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_meritrank_vote_user_mutation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    _counter integer;
BEGIN
    IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
        UPDATE user_vsids SET counter = counter + 1 WHERE user_id = NEW.subject RETURNING counter INTO _counter;
        PERFORM mr_put_edge(NEW.subject, NEW.object, (NEW.amount)::double precision, ''::text, _counter);
        NEW.ticker = _counter;
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        PERFORM mr_delete_edge(OLD.subject, OLD.object, ''::text);
        RETURN OLD;
    END IF;
END;
$$;


ALTER FUNCTION public.notify_meritrank_vote_user_mutation() OWNER TO postgres;

--
-- Name: on_public_user_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.on_public_user_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  IF NEW.has_picture = false THEN
    _new.blur_hash = '';
    _new.pic_height = 0;
    _new.pic_width = 0;
  END IF;
  RETURN _new;
END;
$$;


ALTER FUNCTION public.on_public_user_update() OWNER TO postgres;

--
-- Name: on_user_created(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.on_user_created() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO user_vsids VALUES (NEW.id, DEFAULT, DEFAULT);
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.on_user_created() OWNER TO postgres;

--
-- Name: opinion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.opinion (
    id text DEFAULT concat('O', "substring"((gen_random_uuid())::text, '\w{12}'::text)) NOT NULL,
    subject text NOT NULL,
    object text NOT NULL,
    content text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    amount integer NOT NULL,
    ticker integer DEFAULT 0 NOT NULL,
    CONSTRAINT amount_value CHECK ((amount <> 0)),
    CONSTRAINT opinion_content_length CHECK (((char_length(content) > 0) AND (char_length(content) <= 2048)))
);


ALTER TABLE public.opinion OWNER TO postgres;

--
-- Name: opinion_get_scores(public.opinion, json); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.opinion_get_scores(opinion_row public.opinion, hasura_session json) RETURNS SETOF public.mutual_score
    LANGUAGE sql STABLE
    AS $$

SELECT

  src,

  dst,

  score_cluster_of_src AS src_score,

  score_cluster_of_dst AS dst_score

FROM mr_node_score(

    hasura_session ->> 'x-hasura-user-id',

    opinion_row.id,

    null

);

$$;


ALTER FUNCTION public.opinion_get_scores(opinion_row public.opinion, hasura_session json) OWNER TO postgres;

--
-- Name: rating(text, json); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rating(context text, hasura_session json) RETURNS SETOF public.mutual_score
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT
    src,
    dst,
    score_cluster_of_src AS src_score,
    score_cluster_of_dst AS dst_score
FROM mr_mutual_scores(
    hasura_session->>'x-hasura-user-id',
    context
);
$$;


ALTER FUNCTION public.rating(context text, hasura_session json) OWNER TO postgres;

--
-- Name: set_current_timestamp_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_current_timestamp_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$;


ALTER FUNCTION public.set_current_timestamp_updated_at() OWNER TO postgres;

--
-- Name: edge; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.edge AS
 SELECT ''::text AS src,
    ''::text AS dst,
    (0)::double precision AS score
  WHERE false;


ALTER VIEW public.edge OWNER TO postgres;

--
-- Name: updates(text, json); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.updates(prefix text, hasura_session json) RETURNS SETOF public.edge
    LANGUAGE sql
    AS $$
WITH new_edges AS (
  SELECT
    *
  FROM
    mr_fetch_new_edges(hasura_session ->> 'x-hasura-user-id', prefix)
),
new_filter AS (
  INSERT INTO
    user_updates
  VALUES(
      hasura_session ->> 'x-hasura-user-id',
      mr_get_new_edges_filter(hasura_session ->> 'x-hasura-user-id')
    ) ON CONFLICT DO NOTHING
)
SELECT
  *
FROM
  new_edges;
$$;


ALTER FUNCTION public.updates(prefix text, hasura_session json) OWNER TO postgres;

--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id text DEFAULT concat('U', "substring"((gen_random_uuid())::text, '\w{12}'::text)) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    title text DEFAULT ''::text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    has_picture boolean DEFAULT false NOT NULL,
    public_key text NOT NULL,
    pic_height integer DEFAULT 0 NOT NULL,
    pic_width integer DEFAULT 0 NOT NULL,
    blur_hash text DEFAULT ''::text NOT NULL,
    CONSTRAINT user__description_len CHECK ((char_length(description) <= 2048)),
    CONSTRAINT user__title_len CHECK ((char_length(title) <= 128))
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: user_get_my_vote(public."user", json); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.user_get_my_vote(user_row public."user", hasura_session json) RETURNS integer
    LANGUAGE sql STABLE
    AS $$
SELECT COALESCE((SELECT amount FROM vote_user WHERE subject = (hasura_session ->> 'x-hasura-user-id')::TEXT AND object = user_row.id), 0);
$$;


ALTER FUNCTION public.user_get_my_vote(user_row public."user", hasura_session json) OWNER TO postgres;

--
-- Name: user_get_scores(public."user", json); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.user_get_scores(user_row public."user", hasura_session json) RETURNS SETOF public.mutual_score
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT
  src,
  dst,
  score_cluster_of_src AS src_score,
  score_cluster_of_dst AS dst_score
FROM mr_node_score(
    hasura_session ->> 'x-hasura-user-id',
    user_row.id,
    hasura_session ->> 'x-hasura-query-context'
)
$$;


ALTER FUNCTION public.user_get_scores(user_row public."user", hasura_session json) OWNER TO postgres;

--
-- Name: beacon_pinned; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.beacon_pinned (
    user_id text NOT NULL,
    beacon_id text NOT NULL
);


ALTER TABLE public.beacon_pinned OWNER TO postgres;

--
-- Name: message; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.message (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    subject text NOT NULL,
    object text NOT NULL,
    message text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    delivered boolean DEFAULT false NOT NULL,
    CONSTRAINT message_message_length CHECK ((char_length(message) > 0))
);


ALTER TABLE public.message OWNER TO postgres;

--
-- Name: user_context; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_context (
    user_id text NOT NULL,
    context_name text NOT NULL,
    CONSTRAINT user_context_name_length CHECK (((char_length(context_name) >= 3) AND (char_length(context_name) <= 32)))
);


ALTER TABLE public.user_context OWNER TO postgres;

--
-- Name: user_updates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_updates (
    user_id text NOT NULL,
    filter bytea NOT NULL
);


ALTER TABLE public.user_updates OWNER TO postgres;

--
-- Name: user_vsids; Type: TABLE; Schema: public; Owner: postgres
--

CREATE UNLOGGED TABLE public.user_vsids (
    user_id text NOT NULL,
    counter integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.user_vsids OWNER TO postgres;

--
-- Name: vote_beacon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vote_beacon (
    subject text NOT NULL,
    object text NOT NULL,
    amount integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    ticker integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.vote_beacon OWNER TO postgres;

--
-- Name: vote_comment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vote_comment (
    subject text NOT NULL,
    object text NOT NULL,
    amount integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    ticker integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.vote_comment OWNER TO postgres;

--
-- Name: vote_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vote_user (
    subject text NOT NULL,
    object text NOT NULL,
    amount integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    ticker integer DEFAULT 0 NOT NULL,
    CONSTRAINT vote_user__amount CHECK (((amount >= '-1'::integer) AND (amount <= 1)))
);


ALTER TABLE public.vote_user OWNER TO postgres;

--
-- Name: beacon_pinned beacon_pinned_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beacon_pinned
    ADD CONSTRAINT beacon_pinned_pkey PRIMARY KEY (user_id, beacon_id);


--
-- Name: beacon beacon_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beacon
    ADD CONSTRAINT beacon_pkey PRIMARY KEY (id);


--
-- Name: comment comment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_pkey PRIMARY KEY (id);


--
-- Name: message message_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_pkey PRIMARY KEY (id);


--
-- Name: opinion opinion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opinion
    ADD CONSTRAINT opinion_pkey PRIMARY KEY (id);


--
-- Name: opinion opinion_subject_object_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opinion
    ADD CONSTRAINT opinion_subject_object_key UNIQUE (subject, object);


--
-- Name: user_context user_context_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_context
    ADD CONSTRAINT user_context_pkey PRIMARY KEY (user_id, context_name);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: user user_public_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_public_key_key UNIQUE (public_key);


--
-- Name: user_updates user_updates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_updates
    ADD CONSTRAINT user_updates_pkey PRIMARY KEY (user_id);


--
-- Name: user_vsids user_vsids_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_vsids
    ADD CONSTRAINT user_vsids_pkey PRIMARY KEY (user_id);


--
-- Name: vote_beacon vote_beacon_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vote_beacon
    ADD CONSTRAINT vote_beacon_pkey PRIMARY KEY (subject, object);


--
-- Name: vote_comment vote_comment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vote_comment
    ADD CONSTRAINT vote_comment_pkey PRIMARY KEY (subject, object);


--
-- Name: vote_user vote_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vote_user
    ADD CONSTRAINT vote_user_pkey PRIMARY KEY (subject, object);


--
-- Name: beacon_author_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX beacon_author_id ON public.beacon USING btree (user_id);


--
-- Name: message_by_object; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX message_by_object ON public.message USING btree (object);


--
-- Name: message_by_subject; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX message_by_subject ON public.message USING btree (subject);


--
-- Name: beacon notify_hasura_beacon_mutate_INSERT; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "notify_hasura_beacon_mutate_INSERT" AFTER INSERT ON public.beacon FOR EACH ROW EXECUTE FUNCTION hdb_catalog."notify_hasura_beacon_mutate_INSERT"();


--
-- Name: beacon notify_hasura_user_mutate_UPDATE; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "notify_hasura_user_mutate_UPDATE" AFTER UPDATE ON public.beacon FOR EACH ROW EXECUTE FUNCTION hdb_catalog."notify_hasura_user_mutate_UPDATE"();


--
-- Name: user notify_hasura_user_mutate_UPDATE; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "notify_hasura_user_mutate_UPDATE" AFTER UPDATE ON public."user" FOR EACH ROW EXECUTE FUNCTION hdb_catalog."notify_hasura_user_mutate_UPDATE"();


--
-- Name: beacon notify_meritrank_beacon_mutation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER notify_meritrank_beacon_mutation AFTER INSERT OR DELETE ON public.beacon FOR EACH ROW EXECUTE FUNCTION public.notify_meritrank_beacon_mutation();


--
-- Name: comment notify_meritrank_comment_mutation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER notify_meritrank_comment_mutation AFTER INSERT OR DELETE ON public.comment FOR EACH ROW EXECUTE FUNCTION public.notify_meritrank_comment_mutation();


--
-- Name: opinion notify_meritrank_opinion_mutation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER notify_meritrank_opinion_mutation AFTER INSERT OR DELETE ON public.opinion FOR EACH ROW EXECUTE FUNCTION public.notify_meritrank_opinion_mutation();


--
-- Name: vote_beacon notify_meritrank_vote_beacon_mutation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER notify_meritrank_vote_beacon_mutation AFTER INSERT OR UPDATE ON public.vote_beacon FOR EACH ROW EXECUTE FUNCTION public.notify_meritrank_vote_beacon_mutation();


--
-- Name: vote_comment notify_meritrank_vote_comment_mutation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER notify_meritrank_vote_comment_mutation AFTER INSERT OR UPDATE ON public.vote_comment FOR EACH ROW EXECUTE FUNCTION public.notify_meritrank_vote_comment_mutation();


--
-- Name: vote_user notify_meritrank_vote_user_mutation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER notify_meritrank_vote_user_mutation AFTER INSERT OR UPDATE ON public.vote_user FOR EACH ROW EXECUTE FUNCTION public.notify_meritrank_vote_user_mutation();


--
-- Name: user on_public_user_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER on_public_user_update BEFORE UPDATE ON public."user" FOR EACH ROW EXECUTE FUNCTION public.on_public_user_update();


--
-- Name: user on_user_created; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER on_user_created AFTER INSERT ON public."user" FOR EACH ROW EXECUTE FUNCTION public.on_user_created();


--
-- Name: beacon set_public_beacon_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_public_beacon_updated_at BEFORE UPDATE ON public.beacon FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();


--
-- Name: TRIGGER set_public_beacon_updated_at ON beacon; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TRIGGER set_public_beacon_updated_at ON public.beacon IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- Name: message set_public_message_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_public_message_updated_at BEFORE UPDATE ON public.message FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();


--
-- Name: TRIGGER set_public_message_updated_at ON message; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TRIGGER set_public_message_updated_at ON public.message IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- Name: user_vsids set_public_user_vsids_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_public_user_vsids_updated_at BEFORE UPDATE ON public.user_vsids FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();


--
-- Name: TRIGGER set_public_user_vsids_updated_at ON user_vsids; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TRIGGER set_public_user_vsids_updated_at ON public.user_vsids IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- Name: vote_beacon set_public_vote_beacon_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_public_vote_beacon_updated_at BEFORE UPDATE ON public.vote_beacon FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();


--
-- Name: TRIGGER set_public_vote_beacon_updated_at ON vote_beacon; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TRIGGER set_public_vote_beacon_updated_at ON public.vote_beacon IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- Name: vote_comment set_public_vote_comment_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_public_vote_comment_updated_at BEFORE UPDATE ON public.vote_comment FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();


--
-- Name: TRIGGER set_public_vote_comment_updated_at ON vote_comment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TRIGGER set_public_vote_comment_updated_at ON public.vote_comment IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- Name: vote_user set_public_vote_user_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_public_vote_user_updated_at BEFORE UPDATE ON public.vote_user FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();


--
-- Name: TRIGGER set_public_vote_user_updated_at ON vote_user; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TRIGGER set_public_vote_user_updated_at ON public.vote_user IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- Name: beacon_pinned beacon_pinned_beacon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beacon_pinned
    ADD CONSTRAINT beacon_pinned_beacon_id_fkey FOREIGN KEY (beacon_id) REFERENCES public.beacon(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: beacon_pinned beacon_pinned_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beacon_pinned
    ADD CONSTRAINT beacon_pinned_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: beacon beacon_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beacon
    ADD CONSTRAINT beacon_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: comment comment_beacon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_beacon_id_fkey FOREIGN KEY (beacon_id) REFERENCES public.beacon(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: comment comment_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: message message_object_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_object_fkey FOREIGN KEY (object) REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: message message_subject_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_subject_fkey FOREIGN KEY (subject) REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: opinion opinion_object_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opinion
    ADD CONSTRAINT opinion_object_fkey FOREIGN KEY (object) REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: opinion opinion_subject_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opinion
    ADD CONSTRAINT opinion_subject_fkey FOREIGN KEY (subject) REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: user_context user_context_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_context
    ADD CONSTRAINT user_context_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: user_updates user_updates_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_updates
    ADD CONSTRAINT user_updates_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: user_vsids user_vsids_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_vsids
    ADD CONSTRAINT user_vsids_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: vote_beacon vote_beacon_object_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vote_beacon
    ADD CONSTRAINT vote_beacon_object_fkey FOREIGN KEY (object) REFERENCES public.beacon(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: vote_beacon vote_beacon_subject_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vote_beacon
    ADD CONSTRAINT vote_beacon_subject_fkey FOREIGN KEY (subject) REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: vote_comment vote_comment_object_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vote_comment
    ADD CONSTRAINT vote_comment_object_fkey FOREIGN KEY (object) REFERENCES public.comment(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: vote_comment vote_comment_subject_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vote_comment
    ADD CONSTRAINT vote_comment_subject_fkey FOREIGN KEY (subject) REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: vote_user vote_user_object_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vote_user
    ADD CONSTRAINT vote_user_object_fkey FOREIGN KEY (object) REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: vote_user vote_user_subject_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vote_user
    ADD CONSTRAINT vote_user_subject_fkey FOREIGN KEY (subject) REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

