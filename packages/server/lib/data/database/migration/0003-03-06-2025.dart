part of '_migrations.dart';

// Triggers Functions
final m0003 = Migration('0003', [
  r'''
CREATE OR REPLACE FUNCTION public.beacon_before_insert()
  RETURNS trigger
  LANGUAGE plpgsql
  AS $$
BEGIN
  UPDATE user_vsids SET counter = counter + 1
    WHERE user_id = NEW.user_id
    RETURNING counter INTO NEW.ticker;
  RETURN NEW;
END;
$$;
''',
  //
  r'''
CREATE OR REPLACE FUNCTION public.comment_before_insert()
  RETURNS trigger
  LANGUAGE plpgsql
  AS $$
BEGIN
  UPDATE user_vsids SET counter = counter + 1
    WHERE user_id = NEW.user_id
    RETURNING counter INTO NEW.ticker;
  RETURN NEW;
END;
$$;
''',
  //
  r'''
CREATE OR REPLACE FUNCTION public.notify_meritrank_beacon_mutation()
  RETURNS trigger
  LANGUAGE plpgsql
  AS $$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    PERFORM mr_put_edge(
      NEW.id,
      NEW.user_id,
      1::double precision,
      NEW.context,
      0
    );
    PERFORM mr_put_edge(
      NEW.user_id,
      NEW.id,
      1::double precision,
      NEW.context,
      NEW.ticker
    );
    RETURN NEW;

  ELSIF (TG_OP = 'DELETE') THEN
    PERFORM mr_delete_edge(OLD.id, OLD.user_id, OLD.context);
    PERFORM mr_delete_edge(OLD.user_id, OLD.id, OLD.context);
    RETURN OLD;
  END IF;
END;
$$;
''',
  //
  r'''
CREATE OR REPLACE FUNCTION public.notify_meritrank_comment_mutation()
  RETURNS trigger
  LANGUAGE plpgsql
  AS $$
DECLARE
  context text;
BEGIN
  SELECT beacon.context
    INTO context
    FROM beacon
    WHERE beacon.id = NEW.beacon_id;

  IF (TG_OP = 'INSERT') THEN
    PERFORM mr_put_edge(
      NEW.id,
      NEW.user_id,
      1::double precision,
      context,
      0
    );
    PERFORM mr_put_edge(
      NEW.user_id,
      NEW.id,
      1::double precision,
      context,
      NEW.ticker
    );
    RETURN NEW;

  ELSIF (TG_OP = 'DELETE') THEN
    PERFORM mr_delete_edge(OLD.id, OLD.user_id, context);
    PERFORM mr_delete_edge(OLD.user_id, OLD.id, context);
    RETURN OLD;
  END IF;
END;
$$;
''',
  //
  r'''
CREATE OR REPLACE FUNCTION public.notify_meritrank_opinion_mutation()
  RETURNS trigger
  LANGUAGE plpgsql
  AS $$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    PERFORM mr_put_edge(
      NEW.subject,
      NEW.id,
      (abs(NEW.amount))::double precision,
      '',
      NEW.ticker
    );
    PERFORM mr_put_edge(
      NEW.id,
      NEW.subject,
      (1)::double precision,
      '',
      NEW.ticker
    );
    PERFORM mr_put_edge(
      NEW.id,
      NEW.object,
      (sign(NEW.amount))::double precision,
      '',
      NEW.ticker
    );
    RETURN NEW;

  ELSIF (TG_OP = 'DELETE') THEN
    PERFORM mr_delete_edge(OLD.subject, OLD.id);
    PERFORM mr_delete_edge(OLD.id, OLD.subject);
    PERFORM mr_delete_edge(OLD.id, OLD.object);
    RETURN OLD;
  END IF;
END;
$$;
''',
  //
  r'''
CREATE OR REPLACE FUNCTION public.notify_meritrank_vote_beacon_mutation()
  RETURNS trigger
  LANGUAGE plpgsql
  AS $$
DECLARE
  _context text;
BEGIN
  SELECT beacon.context
    INTO STRICT _context
    FROM beacon
    WHERE beacon.id = NEW.object;

  IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
    PERFORM mr_put_edge(
      NEW.subject,
      NEW.object,
      (NEW.amount)::double precision,
      _context,
      NEW.ticker
    );
    RETURN NEW;

  ELSIF (TG_OP = 'DELETE') THEN
    PERFORM mr_delete_edge(
      OLD.subject,
      OLD.object,
      _context
    );
    RETURN OLD;
  END IF;
END;
$$;
''',
  //
  r'''
CREATE OR REPLACE FUNCTION public.notify_meritrank_vote_comment_mutation()
  RETURNS trigger
  LANGUAGE plpgsql
  AS $$
DECLARE
  _context text;
  beacon_id text;
BEGIN
  SELECT comment.beacon_id
    INTO beacon_id
    FROM comment
    WHERE comment.id = NEW.object;

  SELECT beacon.context
    INTO _context
    FROM beacon
    WHERE beacon.id = beacon_id;

  IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
    PERFORM mr_put_edge(
      NEW.subject,
      NEW.object,
      (NEW.amount)::double precision,
      _context,
      NEW.ticker
    );
    RETURN NEW;

  ELSIF (TG_OP = 'DELETE') THEN
    PERFORM mr_delete_edge(
      OLD.subject,
      OLD.object,
      _context
    );
    RETURN OLD;
  END IF;
END;
$$;
''',
  //
  r'''
CREATE OR REPLACE FUNCTION public.notify_meritrank_vote_user_mutation()
  RETURNS trigger
  LANGUAGE plpgsql
  AS $$
BEGIN
  IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
    PERFORM mr_put_edge(
      NEW.subject,
      NEW.object,
      (NEW.amount)::double precision,
      ''::text, NEW.ticker
    );
    RETURN NEW;

  ELSIF (TG_OP = 'DELETE') THEN
    PERFORM mr_delete_edge(
      OLD.subject,
      OLD.object,
      ''::text
    );
    RETURN OLD;
  END IF;
END;
$$;
''',
  //
  r'''
CREATE OR REPLACE FUNCTION public.on_public_user_update()
  RETURNS trigger
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
''',
  //
  r'''
CREATE OR REPLACE FUNCTION public.on_user_created()
  RETURNS trigger
  LANGUAGE plpgsql
  AS $$
BEGIN
  INSERT INTO user_vsids
    VALUES (NEW.id, DEFAULT, DEFAULT);
  RETURN NEW;
END;
$$;
''',
  //
  r'''
CREATE OR REPLACE FUNCTION public.opinion_before_insert()
  RETURNS trigger
  LANGUAGE plpgsql
  AS $$
BEGIN
  UPDATE user_vsids SET counter = counter + 1
    WHERE user_id = NEW.subject
    RETURNING counter INTO NEW.ticker;
  RETURN NEW;
END;
$$;
''',
  //
  r'''
CREATE OR REPLACE FUNCTION public.vote_beacon_before_insert()
  RETURNS trigger
  LANGUAGE plpgsql
  AS $$
BEGIN
  UPDATE user_vsids SET counter = counter + 1
    WHERE user_id = NEW.subject
    RETURNING counter INTO NEW.ticker;
  RETURN NEW;
END;
$$;
''',
  //
  r'''
CREATE OR REPLACE FUNCTION public.vote_comment_before_insert()
  RETURNS trigger
  LANGUAGE plpgsql
  AS $$
BEGIN
  UPDATE user_vsids SET counter = counter + 1
    WHERE user_id = NEW.subject
    RETURNING counter INTO NEW.ticker;
  RETURN NEW;
END;
$$;
''',
  //
  r'''
CREATE OR REPLACE FUNCTION public.vote_user_before_insert()
  RETURNS trigger
  LANGUAGE plpgsql
  AS $$
BEGIN
  UPDATE user_vsids SET counter = counter + 1
    WHERE user_id = NEW.subject
    RETURNING counter INTO NEW.ticker;
  RETURN NEW;
END;
$$;
''',

  // Triggers
  '''
CREATE OR REPLACE TRIGGER notify_meritrank_beacon_mutation
  AFTER INSERT OR DELETE ON public.beacon
  FOR EACH ROW EXECUTE FUNCTION public.notify_meritrank_beacon_mutation();
''',
  //
  '''
CREATE OR REPLACE TRIGGER notify_meritrank_comment_mutation
  AFTER INSERT OR DELETE ON public.comment
  FOR EACH ROW EXECUTE FUNCTION public.notify_meritrank_comment_mutation();
''',
  //
  '''
CREATE OR REPLACE TRIGGER notify_meritrank_opinion_mutation
  AFTER INSERT OR DELETE ON public.opinion
  FOR EACH ROW EXECUTE FUNCTION public.notify_meritrank_opinion_mutation();
''',
  //
  '''
CREATE OR REPLACE TRIGGER notify_meritrank_vote_beacon_mutation
  AFTER INSERT OR UPDATE ON public.vote_beacon
  FOR EACH ROW EXECUTE FUNCTION public.notify_meritrank_vote_beacon_mutation();
''',
  //
  '''
CREATE OR REPLACE TRIGGER notify_meritrank_vote_comment_mutation
  AFTER INSERT OR UPDATE ON public.vote_comment
  FOR EACH ROW EXECUTE FUNCTION public.notify_meritrank_vote_comment_mutation();
''',
  //
  '''
CREATE OR REPLACE TRIGGER notify_meritrank_vote_user_mutation
  AFTER INSERT OR UPDATE ON public.vote_user
  FOR EACH ROW EXECUTE FUNCTION public.notify_meritrank_vote_user_mutation();
''',
  //
  '''
CREATE OR REPLACE TRIGGER on_public_user_update
  BEFORE UPDATE ON public."user"
  FOR EACH ROW EXECUTE FUNCTION public.on_public_user_update();
''',
  //
  '''
CREATE OR REPLACE TRIGGER on_user_created
  AFTER INSERT ON public."user"
  FOR EACH ROW EXECUTE FUNCTION public.on_user_created();
''',
  //
  '''
CREATE OR REPLACE TRIGGER public_beacon_before_insert
  BEFORE INSERT ON public.beacon
  FOR EACH ROW EXECUTE FUNCTION public.beacon_before_insert();
''',
  //
  '''
CREATE OR REPLACE TRIGGER public_comment_before_insert
  BEFORE INSERT ON public.comment
  FOR EACH ROW EXECUTE FUNCTION public.comment_before_insert();
''',
  //
  '''
CREATE OR REPLACE TRIGGER public_opinion_before_insert
  BEFORE INSERT ON public.opinion
  FOR EACH ROW EXECUTE FUNCTION public.opinion_before_insert();
''',
  //
  '''
CREATE OR REPLACE TRIGGER public_vote_beacon_before_insert
  BEFORE INSERT ON public.vote_beacon
  FOR EACH ROW EXECUTE FUNCTION public.vote_beacon_before_insert();
''',
  //
  '''
CREATE OR REPLACE TRIGGER public_vote_comment_before_insert
  BEFORE INSERT ON public.vote_comment
  FOR EACH ROW EXECUTE FUNCTION public.vote_comment_before_insert();
''',
  //
  '''
CREATE OR REPLACE TRIGGER public_vote_user_before_insert
  BEFORE INSERT ON public.vote_user
  FOR EACH ROW EXECUTE FUNCTION public.vote_user_before_insert();
''',
  //
  '''
CREATE OR REPLACE TRIGGER set_public_beacon_updated_at
  BEFORE UPDATE ON public.beacon
  FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
''',
  //
  '''
CREATE OR REPLACE TRIGGER set_public_invitation_updated_at
  BEFORE UPDATE ON public.invitation
  FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
''',
  //
  '''
CREATE OR REPLACE TRIGGER set_public_message_updated_at
  BEFORE UPDATE ON public.message
  FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
''',
  //
  '''
CREATE OR REPLACE TRIGGER set_public_user_vsids_updated_at
  BEFORE UPDATE ON public.user_vsids
  FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
''',
  //
  '''
CREATE OR REPLACE TRIGGER set_public_vote_beacon_updated_at
  BEFORE UPDATE ON public.vote_beacon
  FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
''',
  //
  '''
CREATE OR REPLACE TRIGGER set_public_vote_comment_updated_at
  BEFORE UPDATE ON public.vote_comment
  FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
''',
  //
  '''
CREATE OR REPLACE TRIGGER set_public_vote_user_updated_at
  BEFORE UPDATE ON public.vote_user
  FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
''',
  //
]);
