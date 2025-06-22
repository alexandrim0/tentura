part of '_migrations.dart';

final m0005 = Migration('0005', [
  // Table
  '''
ALTER TABLE public."user" ADD COLUMN IF NOT EXISTS privileges jsonb;
''',

  // Function
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

  -- Pollings and Variants
  SELECT count(*) INTO STRICT _count FROM (
    SELECT mr_put_edge(
      src,
      dst,
      1.0
    ) FROM (
      SELECT
        polling.id AS dst,
        polling_variant.id AS src
          FROM polling
            JOIN polling_variant
              ON polling.id = polling_variant.polling_id
                WHERE polling.enabled = true
    )
  );
  _total := _total + _count;

  -- Pollings Acts
  SELECT count(*) INTO STRICT _count FROM (
    SELECT mr_put_edge(
      src,
      dst,
      1.0
    ) FROM (
      SELECT
        polling_act.author_id AS src,
        polling_act.polling_variant_id AS dst
          FROM polling_act
            JOIN polling
              ON polling.id = polling_act.polling_id
                WHERE polling.enabled = true
    )
  );
  _total := _total + _count;

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
