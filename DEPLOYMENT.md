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
