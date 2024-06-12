#! /bin/zsh

cd backend

. .venv/bin/activate

python3 app.py &

mailhog &

redis-server &

celery -A app:celery_app worker --loglevel INFO &

celery -A app:celery_app beat --loglevel INFO &
