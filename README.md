[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/lowcoder-1?utm_medium=integration&utm_source=button&utm_campaign=lowcoder)

# Lowcoder on Railway

A Railway template for [Lowcoder](https://github.com/lowcoder-org/lowcoder), the open-source low-code platform for internal tools, admin panels, dashboards and customer-facing apps (an alternative to Retool, Appsmith and Tooljet).

**Version:** Lowcoder Community Edition **2.7.6** (latest stable release), from the official all-in-one image
`lowcoderorg/lowcoder-ce:2.7.6@sha256:4a8b800a9454108546808cc88ed3305cc2533fb25b89326c26139848254dbd61`.

## What the template deploys

| Service | Source | Purpose |
|---|---|---|
| **Lowcoder** | this repo (`Dockerfile`) | Web UI (nginx), API service (Java) and Node service in one container, on port 3000 with a public Railway domain. Health check: `/api/status/health` |
| **MongoDB** | Railway MongoDB | All Lowcoder data: users, workspaces, apps, queries, data sources and uploaded files (GridFS). Has a volume |
| **Redis** | Railway Redis | Sessions and cache |

The wrapper (`railway-start.sh`) switches off the image's embedded MongoDB and Redis, sets the public URL from the Railway domain, sends every service's log to Railway's log view, and refuses to start if any secret is missing or still an upstream example value.

## First login

1. Open the public URL and **sign up right away**. Lowcoder keeps sign-up open until the first workspace admin exists, and that first account becomes the admin of its workspace. After that, sign-up is closed (`LOWCODER_EMAIL_SIGNUP_ENABLED=false`).
2. There is also a super admin account: `LOWCODER_SUPERUSER_USERNAME` (default `admin@localhost`) with the generated password in `LOWCODER_SUPERUSER_PASSWORD` (see the Lowcoder service's **Variables** tab).

To let teammates register, set `LOWCODER_EMAIL_SIGNUP_ENABLED=true` on the Lowcoder service (and `LOWCODER_WORKSPACE_MODE=ENTERPRISE` if everyone should share one workspace instead of each getting their own).

## Variables

| Variable | Default | Notes |
|---|---|---|
| `PORT` | `3000` | Lowcoder's nginx port |
| `LOWCODER_MONGODB_URL` | `${{MongoDB.MONGO_URL}}/lowcoder?authSource=admin` | MongoDB connection |
| `LOWCODER_REDIS_URL` | `${{Redis.REDIS_URL}}` | Redis connection |
| `LOWCODER_SUPERUSER_USERNAME` | `admin@localhost` | Super admin login |
| `LOWCODER_SUPERUSER_PASSWORD` | generated | Super admin password |
| `LOWCODER_DB_ENCRYPTION_PASSWORD`, `LOWCODER_DB_ENCRYPTION_SALT` | generated | Encrypt data source credentials in MongoDB. **Never change them after the first deploy**, or saved credentials can't be decrypted |
| `LOWCODER_API_KEY_SECRET` | generated | Signs API keys |
| `LOWCODER_NODE_SERVICE_SECRET`, `LOWCODER_NODE_SERVICE_SECRET_SALT` | generated | Secure traffic between the API and Node services |

Optional, not set by the template: SMTP for password-reset and invitation emails (`LOWCODER_ADMIN_SMTP_HOST`, `LOWCODER_ADMIN_SMTP_PORT`, `LOWCODER_ADMIN_SMTP_USERNAME`, `LOWCODER_ADMIN_SMTP_PASSWORD`, `LOWCODER_EMAIL_NOTIFICATIONS_SENDER`), `LOWCODER_PUBLIC_URL` for a custom domain, and the other settings in Lowcoder's [docker README](https://github.com/lowcoder-org/lowcoder/tree/main/deploy/docker).

## Updates

The Lowcoder service builds from this repo. When the pin in `Dockerfile` is bumped and merged to `main`, Railway shows an "update available" notice to everyone who deployed the template, and they choose when to apply it. Read `CHANGELOG.md` first. Back up MongoDB before upgrading across a minor or major version.

## License

The wrapper files in this repo are MIT. Lowcoder itself is AGPL-3.0.
