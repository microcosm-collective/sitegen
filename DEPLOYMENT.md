# Deployment Instructions

These are based on the instructions for microweb, and assume you've done the basics
there (i.e. created a server etc).

## Open the firewall

```bash
# python server
# from api
sudo ufw allow from 192.168.165.21 to any port 9001
# from lb
sudo ufw allow from 192.168.207.198 to any port 9001
```

## Create dokku app

Remote:

```bash
dokku apps:create sitegen
```

## Push the git repo to the dokku app

Local:

```bash
git remote add lfgssdemo dokku@lfgssdemo:sitegen
git push lfgssdemo
# or:
git push lfgssdemo HEAD:main
```

## Configure the dokku app

Remote:

```bash
# serve on port 9001 for consistency with previous servers
dokku ports:add sitegen http:9001:5000
dokku domains:add sitegen microcosm.app

# share the memcached instance with microweb
dokku memcached:link microweb-memcached sitegen

dokku config:set --no-restart sitegen DJANGO_SETTINGS_MODULE=sitegen.settings
dokku config:set --no-restart sitegen PYTHONPATH=.
dokku config:set --no-restart sitegen MEMCACHE_HOST=dokku-memcached-microweb-memcached
dokku config:set --no-restart sitegen CLIENT_SECRET=123456
# use single quotes if you have special chars!
dokku config:set --no-restart sitegen SECRET_KEY='!aoeui12345'

dokku nginx:set sitegen proxy-connect-timeout 90s
dokku nginx:set sitegen proxy-send-timeout 90s
dokku nginx:set sitegen proxy-read-timeout 90s
dokku nginx:set sitegen proxy-buffers "32 4k"
dokku nginx:set sitegen client-max-body-size 30m
# nb. if forwarded-proto is set to $scheme, gunicorn sees http
dokku nginx:set sitegen x-forwarded-proto-value https

dokku ps:rebuild sitegen
```

## Check the logs

```bash
# check the application logs
dokku logs sitegen
# check the nginx logs
tail /var/log/nginx/sitegen-error.log
```
