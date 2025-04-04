FROM python:2.7

ENV APP_HOME=/srv/www/django/sitegen/


WORKDIR ${APP_HOME}

RUN apt-get -qq update && \
    apt-get -yq install --no-install-recommends \
    build-essential \
    libevent-dev \
    libmemcached-dev \
    zlib1g-dev && \
    apt-get -yq --purge autoremove && \
    apt-get -q clean && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt /${APP_HOME}

RUN python -m pip install --upgrade pip \
    && pip install virtualenv \
    && pip install -r requirements.txt

COPY . /${APP_HOME}

RUN cp sitegen/local_settings.py.production sitegen/local_settings.py

# add dummy user
RUN useradd -Ms /bin/bash -u1100 microweb

RUN mkdir -p /srv/www/django/static/
# The correct thing to do is run collectstatic like this:
# RUN python manage.py collectstatic --pythonpath=. --settings=sitegen.settings
# However for some reason the staticfiles module is not loading at this point
# (You can see this by running `python manage.py help` here & inspecting the list).
# Connecting to the container later collectstatic runs fine, however if the files
# aren't in place before gunicorn starts, it won't recognise them & you'll get 404s!
# So let's do our own hacky collectstatic like so:
COPY ./static/ /srv/www/django/static/
RUN chown -R microweb:microweb /srv/www/django/static/

# switch to the unprivileged user to run gunicorn
USER microweb

ENV PORT=80
EXPOSE ${PORT}
CMD python /usr/local/bin/gunicorn sitegen.wsgi -b 0.0.0.0:${PORT}
