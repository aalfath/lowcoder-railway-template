#!/bin/bash
# Railway wrapper for the Lowcoder all-in-one image.
# Sets Railway-friendly defaults, refuses to start with the upstream
# example secrets, then hands over to the image's own entrypoint.
set -e

# MongoDB and Redis run as separate Railway services.
export LOWCODER_MONGODB_ENABLED="${LOWCODER_MONGODB_ENABLED:-false}"
export LOWCODER_REDIS_ENABLED="${LOWCODER_REDIS_ENABLED:-false}"

# Public URL from the Railway domain unless set explicitly.
if [ -z "${LOWCODER_PUBLIC_URL:-}" ] && [ -n "${RAILWAY_PUBLIC_DOMAIN:-}" ]; then
  export LOWCODER_PUBLIC_URL="https://${RAILWAY_PUBLIC_DOMAIN}/"
fi

# Self-registration is off by default: the super admin logs in with
# LOWCODER_SUPERUSER_USERNAME / LOWCODER_SUPERUSER_PASSWORD. Set
# LOWCODER_EMAIL_SIGNUP_ENABLED=true to let other people sign up.
export LOWCODER_EMAIL_SIGNUP_ENABLED="${LOWCODER_EMAIL_SIGNUP_ENABLED:-false}"
export LOWCODER_SUPERUSER_USERNAME="${LOWCODER_SUPERUSER_USERNAME:-admin@localhost}"

# Never run with missing or upstream example secrets.
for v in LOWCODER_SUPERUSER_PASSWORD LOWCODER_DB_ENCRYPTION_PASSWORD LOWCODER_DB_ENCRYPTION_SALT \
         LOWCODER_API_KEY_SECRET LOWCODER_NODE_SERVICE_SECRET LOWCODER_NODE_SERVICE_SECRET_SALT; do
  val="${!v:-}"
  case "$val" in
    ""|lowcoder.org|5a41b090758b39b226603177ef48d73ae9839dd458ccb7e66f7e7cc028d5a50b|62e348319ab9f5c43c3b5a380b4d82525cdb68740f21140e767989b509ab0aa2)
      echo "railway-start: $v is empty or an upstream example value; set a unique secret." >&2
      exit 1 ;;
  esac
done

if [ "$LOWCODER_MONGODB_ENABLED" = "false" ] && [ -z "${LOWCODER_MONGODB_URL:-}" ]; then
  echo "railway-start: LOWCODER_MONGODB_URL is not set." >&2
  exit 1
fi
if [ "$LOWCODER_REDIS_ENABLED" = "false" ] && [ -z "${LOWCODER_REDIS_URL:-}" ]; then
  echo "railway-start: LOWCODER_REDIS_URL is not set." >&2
  exit 1
fi

exec /bin/sh /lowcoder/entrypoint.sh "$@"
