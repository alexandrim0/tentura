part of '_migrations.dart';

final m0006 = Migration(
  '0006',
  [
    // Table
    '''
ALTER TABLE public."user"
  ADD COLUMN IF NOT EXISTS image_id UUID,
  ADD CONSTRAINT user__image_id__fkey FOREIGN KEY (image_id)
    REFERENCES public."image"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
''',
    //
    '''
ALTER TABLE public."beacon"
  ADD COLUMN IF NOT EXISTS image_id UUID,
  ADD CONSTRAINT beacon__image_id__fkey FOREIGN KEY (image_id)
    REFERENCES public."image"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
''',
    //
    '''
ALTER TABLE public."image"
  ADD COLUMN IF NOT EXISTS author_id TEXT,
  ADD CONSTRAINT image__author_id__fkey FOREIGN KEY (author_id)
    REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE;
''',

    // Migrate data
    r'''
DO $$
DECLARE
  _id UUID;
  _user RECORD;
  _beacon RECORD;
BEGIN

  -- User images
  FOR _user IN
    SELECT id, pic_height, pic_width, blur_hash
      FROM public."user"
        WHERE has_picture = true AND image_id IS NULL
  LOOP
    _id := gen_random_uuid();
    INSERT INTO public."image" (id, height, width, hash)
      VALUES (_id, _user.pic_height, _user.pic_width, _user.blur_hash);
    UPDATE public."user" SET image_id = _id WHERE id = _user.id;
  END LOOP;

  -- Beacon images
  FOR _beacon IN
    SELECT id, pic_height, pic_width, blur_hash
      FROM public."beacon"
        WHERE has_picture = true AND image_id IS NULL
  LOOP
    _id := gen_random_uuid();
    INSERT INTO public."image" (id, height, width, hash)
      VALUES (_id, _beacon.pic_height, _beacon.pic_width, _beacon.blur_hash);
    UPDATE public."beacon" SET image_id = _id WHERE id = _beacon.id;
  END LOOP;

END;
$$ LANGUAGE plpgsql;
''',

    // Clean Tables
    '''
ALTER TABLE public."user"
  DROP COLUMN IF EXISTS has_picture,
  DROP COLUMN IF EXISTS pic_height,
  DROP COLUMN IF EXISTS pic_width,
  DROP COLUMN IF EXISTS blur_hash;
''',
    '''
ALTER TABLE public."beacon"
  DROP COLUMN IF EXISTS has_picture,
  DROP COLUMN IF EXISTS pic_height,
  DROP COLUMN IF EXISTS pic_width,
  DROP COLUMN IF EXISTS blur_hash;
''',
  ],
);
