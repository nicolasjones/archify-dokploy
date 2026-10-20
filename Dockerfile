# Archify static site — built from upstream tt-a1i/archify and served by nginx.
# Update ARCHIFY_REF to a commit SHA from https://github.com/tt-a1i/archify/commits/main
FROM node:22-bookworm-slim AS build
ARG ARCHIFY_REPO=https://github.com/tt-a1i/archify.git
ARG ARCHIFY_REF=25cf37080fc8b1dbe758a4efc3935b55f3327083
RUN apt-get update \
 && apt-get install -y --no-install-recommends git ca-certificates \
 && rm -rf /var/lib/apt/lists/*
WORKDIR /src
RUN git init -q \
 && git remote add origin "$ARCHIFY_REPO" \
 && git fetch --depth 1 origin "$ARCHIFY_REF" \
 && git checkout -q FETCH_HEAD
WORKDIR /src/website
RUN npm ci --no-audit --no-fund \
 && ARCHIFY_SITE_TARGET=cloudflare npm run build

FROM nginx:1.27-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /src/website/dist-cloudflare /usr/share/nginx/html
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -qO- http://127.0.0.1/healthz >/dev/null || exit 1
