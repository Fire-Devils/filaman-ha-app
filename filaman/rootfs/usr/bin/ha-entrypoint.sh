#!/bin/sh
# Home Assistant bridge for the FilaMan container.
#
# 1. Translate /data/options.json into the environment variables FilaMan reads.
# 2. Keep per-installation secrets in /data so sessions survive a restart and
#    two installations never share a signing key.
# 3. Hand over to the image's own entrypoint, which takes a backup and runs
#    "alembic upgrade head" before starting gunicorn.
set -e

OPTIONS=/data/options.json
SECRETS=/data/secrets.env

if [ -f "$OPTIONS" ]; then
    set -a
    # python3 ships with the image (python:3.11-slim) — no jq or bashio needed.
    eval "$(python3 - <<'PY'
import json
import shlex

# add-on option -> FilaMan environment variable
MAPPING = {
    "admin_email": "ADMIN_EMAIL",
    "admin_password": "ADMIN_PASSWORD",
    "admin_display_name": "ADMIN_DISPLAY_NAME",
    "admin_language": "ADMIN_LANGUAGE",
    "log_level": "LOG_LEVEL",
    "cors_origins": "CORS_ORIGINS",
    "filamentdb_url": "FILAMENTDB_URL",
}

with open("/data/options.json", encoding="utf-8") as handle:
    options = json.load(handle)

for option, variable in MAPPING.items():
    value = options.get(option)
    if value is None or value == "":
        continue
    value = str(value)
    if variable == "LOG_LEVEL":
        # settings.log_level expects INFO/DEBUG/... in upper case
        value = value.upper()
    print(f"{variable}={shlex.quote(value)}")
PY
)"
    set +a
fi

if [ ! -f "$SECRETS" ]; then
    echo "[filaman] generating per-installation secrets in ${SECRETS}"
    (
        umask 077
        {
            echo "SECRET_KEY=$(python3 -c 'import secrets; print(secrets.token_urlsafe(48))')"
            echo "CSRF_SECRET_KEY=$(python3 -c 'import secrets; print(secrets.token_urlsafe(48))')"
            echo "OIDC_ENC_KEY=$(python3 -c 'import secrets; print(secrets.token_urlsafe(32))')"
        } >"$SECRETS"
    )
fi
set -a
. "$SECRETS"
set +a

# Four slashes: an absolute path inside the persisted /data volume.
export DATABASE_URL="${DATABASE_URL:-sqlite+aiosqlite:////data/filaman.db}"

if [ -z "${ADMIN_EMAIL}" ] || [ -z "${ADMIN_PASSWORD}" ]; then
    echo "[filaman] WARNING: admin_email and admin_password are not both set." >&2
    echo "[filaman] Without them no user is created and you cannot log in." >&2
fi

exec docker-entrypoint.sh "$@"
