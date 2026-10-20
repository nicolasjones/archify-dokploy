# archify-dokploy

Deployment wrapper for [Archify](https://github.com/tt-a1i/archify) in Dokploy (project **SDLC**).

It builds the upstream Astro website as a static site (`ARCHIFY_SITE_TARGET=cloudflare`, root base) and serves it with nginx.

## Update

1. Pick a commit SHA from https://github.com/tt-a1i/archify/commits/main
2. Change `ARG ARCHIFY_REF=<sha>` in `Dockerfile`
3. Commit and push; Dokploy redeploys automatically (or click Deploy).

## Local build

```sh
docker build -t archify:local .
docker run --rm -p 8088:80 archify:local
# http://localhost:8088
```
