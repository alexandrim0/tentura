part of '_migrations.dart';

// Functions
final m0002 = Migration('0002', [
  r'''
CREATE OR REPLACE FUNCTION public.set_current_timestamp_updated_at()
  RETURNS trigger
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
''',
  //
  r'''
CREATE OR REPLACE FUNCTION public.beacon_get_is_pinned(
  beacon_row public.beacon,
  hasura_session json
) RETURNS boolean
  LANGUAGE sql
  STABLE
  AS $$
SELECT COALESCE(
  (SELECT true AS "is_pinned" FROM beacon_pinned WHERE
    user_id = (hasura_session ->> 'x-hasura-user-id')::TEXT
    AND beacon_id = beacon_row.id
  ),
  false
);
$$;
''',
  //
  r'''
CREATE OR REPLACE FUNCTION public.beacon_get_my_vote(
  beacon_row public.beacon,
  hasura_session json
) RETURNS integer
  LANGUAGE sql
  IMMUTABLE
  AS $$
SELECT COALESCE(
  (SELECT amount FROM vote_beacon WHERE
    subject = (hasura_session ->> 'x-hasura-user-id')::TEXT
    AND object = beacon_row.id
  ),
  0
);
$$;
''',
  //
  r'''
CREATE OR REPLACE FUNCTION public.beacon_get_scores(
  beacon_row public.beacon,
  hasura_session json
) RETURNS SETOF public.mutual_score
  LANGUAGE sql
  IMMUTABLE
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
''',
  //
  r'''
CREATE OR REPLACE FUNCTION public.comment_get_my_vote(
  comment_row public.comment,
  hasura_session json
) RETURNS integer
  LANGUAGE sql
  STABLE
  AS $$
SELECT COALESCE(
  (SELECT amount FROM vote_comment WHERE
    subject = (hasura_session ->> 'x-hasura-user-id')::TEXT
    AND object = comment_row.id
  ),
  0
);
$$;
''',
  //
  r'''
CREATE OR REPLACE FUNCTION public.comment_get_scores(
  comment_row public.comment,
  hasura_session json
) RETURNS SETOF public.mutual_score
  LANGUAGE sql
  IMMUTABLE
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
''',
  //
  r'''
CREATE OR REPLACE FUNCTION public.opinion_get_scores(
  opinion_row public.opinion,
  hasura_session json
) RETURNS SETOF public.mutual_score
  LANGUAGE sql
  IMMUTABLE
  AS $$
SELECT
  src,
  dst,
  score_cluster_of_src AS src_score,
  score_cluster_of_dst AS dst_score
FROM mr_neighbors(
  hasura_session ->> 'x-hasura-user-id',
  opinion_row.object,
  2,
  false,
  NULL,
  'O',
  NULL,
  NULL,
  NULL,
  NULL,
  0,
  1
) FETCH FIRST 1 ROW ONLY;
$$;
''',
  //
  r'''
CREATE OR REPLACE FUNCTION public.user_get_my_vote(
  user_row public."user",
  hasura_session json
) RETURNS integer
  LANGUAGE sql
  STABLE
  AS $$
SELECT COALESCE(
  (SELECT amount FROM vote_user
    WHERE subject = (hasura_session ->> 'x-hasura-user-id')::TEXT
      AND object = user_row.id
  ),
  0
);
$$;
''',
  //
  r'''
CREATE OR REPLACE FUNCTION public.user_get_scores(
  user_row public."user",
  hasura_session json
) RETURNS SETOF public.mutual_score
  LANGUAGE sql
  IMMUTABLE
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
''',
  //
  r'''
CREATE OR REPLACE FUNCTION public.updates(prefix text, hasura_session json)
  RETURNS SETOF public.mutual_score
  LANGUAGE sql
  AS $$
WITH new_edges AS (
  SELECT
    src,
    dst,
    score_cluster_of_src AS src_score,
    score_cluster_of_dst AS dst_score
  FROM
    mr_fetch_new_edges(hasura_session ->> 'x-hasura-user-id', prefix)
  ),
  new_filter AS (
    INSERT INTO
      user_updates
    VALUES(
        hasura_session ->> 'x-hasura-user-id',
        mr_get_new_edges_filter(hasura_session ->> 'x-hasura-user-id')
      )
    ON CONFLICT DO NOTHING
  )
SELECT * FROM new_edges;
$$;
''',
  //
  r'''
CREATE OR REPLACE FUNCTION public.opinions(
  object text,
  offset_ integer,
  limit_ integer,
  hasura_session json
) RETURNS SETOF public.mutual_score
  LANGUAGE sql
  IMMUTABLE
  AS $$
SELECT
  src,
  dst,
  score_cluster_of_src AS src_score,
  score_cluster_of_dst AS dst_score
FROM mr_neighbors(
  hasura_session ->> 'x-hasura-user-id',
  object,
  2,
  false,
  NULL,
  'O',
  NULL,
  NULL,
  NULL,
  NULL,
  offset_,
  limit_
);
$$;
''',
  //
  r'''
CREATE OR REPLACE FUNCTION public.rating(context text, hasura_session json)
  RETURNS SETOF public.mutual_score
  LANGUAGE sql
  IMMUTABLE
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
''',
  //
  r'''
CREATE OR REPLACE FUNCTION public.graph(
  focus text,
  context text,
  positive_only boolean,
  hasura_session json
) RETURNS SETOF public.mutual_score
  LANGUAGE sql
  STABLE
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
''',
  //
  r'''
CREATE OR REPLACE FUNCTION public.my_field(context text, hasura_session json)
  RETURNS SETOF public.mutual_score
  LANGUAGE sql
  IMMUTABLE
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
''',
  //
  r'''
CREATE OR REPLACE FUNCTION public.meritrank_init()
  RETURNS integer
  LANGUAGE plpgsql
  STABLE
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
    SELECT mr_put_edge(
      edge.src,
      edge.dst,
      edge.amount,
      '',
      edge.ticker
    ) FROM (
      SELECT vote_user.subject AS src,
        vote_user.object AS dst,
        vote_user.amount AS amount,
        vote_user.ticker
      FROM vote_user
    ) AS edge);
  _total := _total + _count;

  -- Edges Author <-> Beacon
  FOR _beacon IN
    SELECT id, user_id, context, ticker
      FROM "beacon"
  LOOP
    -- Beacon -> Author
    PERFORM mr_put_edge(
      _beacon.id,
      _beacon.user_id,
      1,
      _beacon.context,
      0
    );
    -- Author -> Beacon
    PERFORM mr_put_edge(
      _beacon.user_id,
      _beacon.id,
      1,
      _beacon.context,
      _beacon.ticker
    );
    _total := _total + 2;
  END LOOP;

  -- Edges User -> Beacon (vote)
  SELECT count(*) INTO STRICT _count FROM (
    SELECT mr_put_edge(
      edge.src,
      edge.dst,
      edge.amount,
      edge.context,
      edge.ticker
    ) FROM (
      SELECT vote_beacon.subject AS src,
        vote_beacon.object AS dst,
        vote_beacon.amount AS amount,
        beacon.context AS context,
        vote_beacon.ticker
      FROM vote_beacon
        JOIN beacon ON beacon.id = vote_beacon.object
    ) AS edge);
  _total := _total + _count;

  -- Edges Author <-> Comment
  FOR _comment IN
    SELECT "comment".id, "comment".user_id, context, "comment".ticker
      FROM "comment"
        JOIN "beacon" ON "comment".beacon_id = "beacon".id
  LOOP
    -- Comment -> Author
    PERFORM mr_put_edge(
      _comment.id,
      _comment.user_id,
      1,
      _comment.context,
      0
    );
    -- Author -> Comment
    PERFORM mr_put_edge(
      _comment.user_id,
      _comment.id,
      1,
      _comment.context,
      _comment.ticker
    );
    _total := _total + 2;
  END LOOP;

  -- Edges User -> Comment (vote)
  SELECT count(*) INTO STRICT _count FROM (
    SELECT mr_put_edge(
      edge.src,
      edge.dst,
      edge.amount,
      edge.context,
      edge.ticker
    ) FROM (
      SELECT vote_comment.subject AS src,
        vote_comment.object AS dst,
        vote_comment.amount AS amount,
        beacon.context AS context,
        vote_comment.ticker
      FROM vote_comment
        JOIN "comment" ON "comment".id = vote_comment.object
        JOIN beacon ON beacon.id = "comment".beacon_id
    ) AS edge);
  _total := _total + _count;

  -- Edges for Opinion
  FOR _opinion IN
    SELECT id, subject, object, amount, ticker
      FROM "opinion"
  LOOP
    -- Author -> Opinion
    PERFORM mr_put_edge(
      _opinion.subject,
      _opinion.id,
      (abs(_opinion.amount))::double precision,
      '',
      _opinion.ticker
    );
    -- Opinion -> Author
    PERFORM mr_put_edge(
      _opinion.id,
      _opinion.subject,
      (1)::double precision,
      '',
      _opinion.ticker
    );
    -- Opinion -> User
    PERFORM mr_put_edge(
      _opinion.id,
      _opinion.object,
      (sign(_opinion.amount))::double precision,
      '',
      _opinion.ticker
    );
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
''',
]);
