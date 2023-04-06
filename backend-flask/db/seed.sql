-- this file was manually created
INSERT INTO public.users (display_name, handle, email, cognito_user_id)
VALUES
  ('Andrew Brown', 'andrewbrown' , 'andrew@test.com', 'MOCK'),
  ('Andrew Bayko', 'bayko' , 'bayko@friedfish.com', 'MOCK'),
  ('FM Test', 'fm-test-3' , 'fm.social90@gmail.com', 'MOCK'),
  ('Big Foot', 'bigfoot03' , 'fm.social90+bigfoot@gmail.com', 'MOCK');

INSERT INTO public.activities (user_uuid, message, expires_at)
VALUES
  (
    (SELECT uuid from public.users WHERE users.handle = 'andrewbrown' LIMIT 1),
    'This was imported as seed data!',
    current_timestamp + interval '10 day'
  )