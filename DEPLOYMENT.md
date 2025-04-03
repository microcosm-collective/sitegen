# Deployment Instructions

Remote:

```bash
dokku apps:create sitegen
```

Local:

```bash
git remote add lfgssdemo dokku@lfgssdemo:sitegen
git push lfgssdemo
# or:
git push lfgssdemo HEAD:main
```

```bash
dokku config:set --no-restart sitegen DJANGO_SETTINGS_MODULE=sitegen.settings
dokku config:set --no-restart sitegen PYTHONPATH=.
dokku config:set --no-restart sitegen MEMCACHE_HOST=dokku-memcached-microweb-memcached
dokku config:set --no-restart sitegen CLIENT_SECRET=123456
# use single quotes if you have special chars!
dokku config:set --no-restart sitegen SECRET_KEY='!aoeui12345'
```

```bash
# TODO: setup nginx

dokku ps:rebuild sitegen
```
