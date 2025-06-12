part of '_migrations.dart';

final m0004 = Migration('0004', [
  // Tables
  '''
CREATE TABLE IF NOT EXISTS public.polling (
  id text NOT NULL,
  author_id text NOT NULL,
  question text NOT NULL,
  enabled boolean DEFAULT true NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT polling__author_id__fkey FOREIGN KEY (author_id)
    REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE
);
''',
  //
  '''
CREATE TABLE IF NOT EXISTS public.polling_variant (
  id text NOT NULL,
  polling_id text NOT NULL,
  description text NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT polling_variant__ukey UNIQUE (polling_id, description),
  CONSTRAINT polling_variant__polling_id__fkey FOREIGN KEY (polling_id)
    REFERENCES public.polling(id) ON UPDATE RESTRICT ON DELETE CASCADE
);
''',
  //
  '''
CREATE TABLE IF NOT EXISTS public.polling_act (
  author_id text NOT NULL,
  polling_id text NOT NULL,
  polling_variant_id text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  CONSTRAINT polling_act__pkey PRIMARY KEY (author_id, polling_id),
  CONSTRAINT polling_act__author_id__fkey FOREIGN KEY (author_id)
    REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE,
  CONSTRAINT polling_act__polling_id__fkey FOREIGN KEY (polling_id)
    REFERENCES public.polling(id) ON UPDATE RESTRICT ON DELETE CASCADE,
  CONSTRAINT polling_act__polling_variant_id__fkey FOREIGN KEY (polling_variant_id)
    REFERENCES public.polling_variant(id) ON UPDATE RESTRICT ON DELETE CASCADE
);
''',
  //
  '''
ALTER TABLE public.beacon ADD COLUMN IF NOT EXISTS polling_id text
  CONSTRAINT beacon__polling_id__fkey REFERENCES public.polling(id)
    ON UPDATE RESTRICT ON DELETE CASCADE;
''',
]);
