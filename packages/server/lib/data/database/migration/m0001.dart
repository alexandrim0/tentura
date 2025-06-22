part of '_migrations.dart';

final m0001 = Migration('0001', [
  // Schema
  'CREATE SCHEMA IF NOT EXISTS public;',
  'ALTER SCHEMA public OWNER TO pg_database_owner;',

  // Views
  '''
CREATE OR REPLACE VIEW public.mutual_score AS
  SELECT ''::text AS src,
    ''::text AS dst,
    (0)::double precision AS src_score,
    (0)::double precision AS dst_score
  WHERE false;
''',
  //
  '''
CREATE OR REPLACE VIEW public.edge AS
  SELECT ''::text AS src,
    ''::text AS dst,
    (0)::double precision AS score
  WHERE false;
''',

  // Tables
  r'''
CREATE TABLE IF NOT EXISTS public."user" (
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
  PRIMARY KEY (id),
  CONSTRAINT user_public_key_key UNIQUE (public_key),
  CONSTRAINT user__description_len CHECK ((char_length(description) <= 2048)),
  CONSTRAINT user__title_len CHECK ((char_length(title) <= 128))
);
''',
  //
  '''
CREATE UNLOGGED TABLE IF NOT EXISTS public.user_vsids (
  user_id text NOT NULL,
  counter integer DEFAULT 0 NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL,
  PRIMARY KEY (user_id),
  CONSTRAINT user_vsids_user_id_fkey FOREIGN KEY (user_id)
    REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE
);
''',
  //
  '''
CREATE TABLE IF NOT EXISTS public.user_updates (
  user_id text NOT NULL,
  filter bytea NOT NULL,
  PRIMARY KEY (user_id),
  CONSTRAINT user_updates_user_id_fkey FOREIGN KEY (user_id)
    REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE
);
''',
  //
  '''
CREATE TABLE IF NOT EXISTS public.user_context (
  user_id text NOT NULL,
  context_name text NOT NULL,
  CONSTRAINT user_context_pkey PRIMARY KEY (user_id, context_name),
  CONSTRAINT user_context_name_length CHECK (((char_length(context_name) >= 3) AND (char_length(context_name) <= 32))),
  CONSTRAINT user_context_user_id_fkey FOREIGN KEY (user_id)
    REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE
);
''',
  //
  r'''
CREATE TABLE IF NOT EXISTS public.invitation (
  id text DEFAULT concat('I', "substring"((gen_random_uuid())::text, '\w{12}'::text)) NOT NULL,
  user_id text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL,
  invited_id text,
  PRIMARY KEY (id),
  CONSTRAINT invitation_invited_id_key UNIQUE (invited_id),
  CONSTRAINT invitation_invited_id_fkey FOREIGN KEY (invited_id)
    REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE,
  CONSTRAINT invitation_user_id_fkey FOREIGN KEY (user_id)
    REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE
);
''',
  //
  r'''
CREATE TABLE IF NOT EXISTS public.beacon (
  id text DEFAULT concat('B', "substring"((gen_random_uuid())::text, '\w{12}'::text)) NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL,
  user_id text NOT NULL,
  title text NOT NULL,
  description text NOT NULL,
  enabled boolean DEFAULT true NOT NULL,
  has_picture boolean DEFAULT false NOT NULL,
  lat double precision,
  long double precision,
  context text,
  pic_height integer DEFAULT 0 NOT NULL,
  pic_width integer DEFAULT 0 NOT NULL,
  blur_hash text DEFAULT ''::text NOT NULL,
  ticker integer DEFAULT 0 NOT NULL,
  start_at timestamp with time zone,
  end_at timestamp with time zone,
  PRIMARY KEY (id),
  CONSTRAINT beacon__description_len CHECK ((char_length(description) <= 2048)),
  CONSTRAINT beacon__title_len CHECK ((char_length(title) <= 128)),
  CONSTRAINT beacon_context_name_length CHECK (((char_length(context) >= 3) AND (char_length(context) <= 32))),
  CONSTRAINT beacon_user_id_fkey FOREIGN KEY (user_id)
    REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE
);
''',
  //
  '''
CREATE TABLE IF NOT EXISTS public.beacon_pinned (
  user_id text NOT NULL,
  beacon_id text NOT NULL,
  CONSTRAINT beacon_pinned_pkey PRIMARY KEY (user_id, beacon_id),
  CONSTRAINT beacon_pinned_beacon_id_fkey FOREIGN KEY (beacon_id)
    REFERENCES public.beacon(id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT beacon_pinned_user_id_fkey FOREIGN KEY (user_id)
    REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE
);
''',
  //
  r'''
CREATE TABLE IF NOT EXISTS public.comment (
  id text DEFAULT concat('C', "substring"((gen_random_uuid())::text, '\w{12}'::text)) NOT NULL,
  user_id text NOT NULL,
  content text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  beacon_id text NOT NULL,
  ticker integer DEFAULT 0 NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT comment_content_length CHECK (((char_length(content) > 0) AND (char_length(content) <= 2048))),
  CONSTRAINT comment_beacon_id_fkey FOREIGN KEY (beacon_id)
    REFERENCES public.beacon(id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT comment_user_id_fkey FOREIGN KEY (user_id)
    REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE
);
''',
  //
  r'''
CREATE TABLE IF NOT EXISTS public.opinion (
  id text DEFAULT concat('O', "substring"((gen_random_uuid())::text, '\w{12}'::text)) NOT NULL,
  subject text NOT NULL,
  object text NOT NULL,
  content text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  amount integer NOT NULL,
  ticker integer DEFAULT 0 NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT opinion_subject_object_key UNIQUE (subject, object),
  CONSTRAINT amount_value CHECK ((amount <> 0)),
  CONSTRAINT opinion_content_length CHECK (((char_length(content) > 0) AND (char_length(content) <= 2048))),
  CONSTRAINT opinion_object_fkey FOREIGN KEY (object)
    REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE,
  CONSTRAINT opinion_subject_fkey FOREIGN KEY (subject)
    REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE
);
''',
  //
  '''
CREATE TABLE IF NOT EXISTS public.vote_user (
  subject text NOT NULL,
  object text NOT NULL,
  amount integer NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL,
  ticker integer DEFAULT 0 NOT NULL,
  CONSTRAINT vote_user_pkey PRIMARY KEY (subject, object),
  CONSTRAINT vote_user__amount CHECK (((amount >= '-1'::integer) AND (amount <= 1))),
  CONSTRAINT vote_user_object_fkey FOREIGN KEY (object)
    REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE,
  CONSTRAINT vote_user_subject_fkey FOREIGN KEY (subject)
    REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE
);
''',
  //
  '''
CREATE TABLE IF NOT EXISTS public.vote_beacon (
  subject text NOT NULL,
  object text NOT NULL,
  amount integer NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL,
  ticker integer DEFAULT 0 NOT NULL,
  CONSTRAINT vote_beacon_pkey PRIMARY KEY (subject, object),
  CONSTRAINT vote_beacon_object_fkey FOREIGN KEY (object)
    REFERENCES public.beacon(id) ON UPDATE RESTRICT ON DELETE CASCADE,
  CONSTRAINT vote_beacon_subject_fkey FOREIGN KEY (subject)
    REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE
);
''',
  //
  '''
CREATE TABLE IF NOT EXISTS public.vote_comment (
  subject text NOT NULL,
  object text NOT NULL,
  amount integer NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL,
  ticker integer DEFAULT 0 NOT NULL,
  CONSTRAINT vote_comment_pkey PRIMARY KEY (subject, object),
  CONSTRAINT vote_comment_object_fkey FOREIGN KEY (object)
    REFERENCES public.comment(id) ON UPDATE RESTRICT ON DELETE CASCADE,
  CONSTRAINT vote_comment_subject_fkey FOREIGN KEY (subject)
    REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE
);
''',
  //
  '''
CREATE TABLE IF NOT EXISTS public.message (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  subject text NOT NULL,
  object text NOT NULL,
  message text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL,
  delivered boolean DEFAULT false NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT message_message_length CHECK ((char_length(message) > 0)),
  CONSTRAINT message_object_fkey FOREIGN KEY (object)
    REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE,
  CONSTRAINT message_subject_fkey FOREIGN KEY (subject)
    REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE
);
''',
  //
  '''
CREATE TABLE IF NOT EXISTS public.image (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  hash text DEFAULT ''::text NOT NULL,
  height integer DEFAULT 0 NOT NULL,
  width integer DEFAULT 0 NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  PRIMARY KEY (id)
);
''',

  // Indexes
  '''
CREATE INDEX IF NOT EXISTS beacon_author_id
  ON public.beacon USING btree (user_id);
''',
  //
  '''
CREATE INDEX IF NOT EXISTS invitation_user_id_key
  ON public.invitation USING btree (user_id);
''',
  //
  '''
CREATE INDEX IF NOT EXISTS message_by_object
  ON public.message USING btree (object);
''',
  //
  '''
CREATE INDEX IF NOT EXISTS message_by_subject
  ON public.message USING btree (subject);
''',
]);
