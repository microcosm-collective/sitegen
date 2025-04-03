#!/bin/bash
set -e

# logfile and location
LOGFILE=/var/log/django/sitegen.log
LOGDIR=$(dirname $LOGFILE)

# number of gunicorn workers
NUM_WORKERS=1
HOST='127.0.0.1:8001'

# user/group to run as
USER=django
GROUP=microcosm

# activate virtualenv
source /srv/www/django/sitegenenv/bin/activate

cd /srv/www/django/sitegen
test -d $LOGDIR || mkdir -p $LOGDIR


exec /srv/www/django/sitegenenv/bin/gunicorn_django -b $HOST \
    -w $NUM_WORKERS -k gevent --user=$USER --group=$GROUP --log-level=info \
    --max-requests 5000 --log-file=$LOGFILE 2>>$LOGFILE
