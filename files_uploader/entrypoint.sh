#!/bin/sh

python manage.py migrate
python manage.py collectstatic --noinput

python manage.py createsuperuser \
    --username=$DJANGO_SUPERUSER_USERNAME --noinput \
    --email=$DJANGO_SUPERUSER_EMAIL \
    || true

python manage.py test || exit 1

gunicorn config.wsgi:application --bind $API_HOST:$API_PORT --log-level INFO &
celery -A config worker -l INFO
