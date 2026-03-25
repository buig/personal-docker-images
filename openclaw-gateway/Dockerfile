# syntax=docker/dockerfile:1.6
ARG OPENCLAW_VERSION=v2026.2.12

########## BUILD ##########
FROM node:22-bookworm AS build

ARG OPENCLAW_VERSION

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    git ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

# Bun (requerido por scripts de build en OpenClaw)
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:${PATH}"

RUN corepack enable

WORKDIR /app

# Clona el repo fijado a tag (build reproducible)
RUN git clone --branch "${OPENCLAW_VERSION}" --depth 1 https://github.com/openclaw/openclaw.git /app

# Instala deps y compila
RUN pnpm install --frozen-lockfile
RUN pnpm build
ENV OPENCLAW_PREFER_PNPM=1
RUN pnpm ui:build

########## RUNTIME ##########
FROM node:22-bookworm-slim AS runtime

ENV NODE_ENV=production
ENV OPENCLAW_PREFER_PNPM=1

WORKDIR /app

# Copiamos runtime necesario (incluye node_modules)
COPY --from=build /app /app

# Endurecimiento básico: no root
RUN chown -R node:node /app
USER node

# Gateway por defecto (igual que upstream)
CMD ["node","openclaw.mjs","gateway","--allow-unconfigured"]
