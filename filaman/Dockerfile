# Thin wrapper around the published FilaMan image.
#
# The app image knows nothing about Home Assistant: options arrive as
# /data/options.json, while FilaMan reads plain environment variables. The
# entrypoint added here translates one into the other and then hands over to
# the image's own entrypoint (backup + alembic upgrade + gunicorn).
#
# FILAMAN_VERSION is deliberately separate from the add-on version: app tags
# carry a "v" prefix, and an add-on-only fix may ship as 1.3.3-2 without a new
# app release.
ARG FILAMAN_VERSION=v1.3.5
FROM ghcr.io/fire-devils/filaman-system:${FILAMAN_VERSION}

# Every persistent path lives under /app/data (database, backups, uploads,
# manufacturer logos, plugins, logs). Home Assistant persists /data, so point
# one at the other instead of patching the app.
RUN rm -rf /app/data && ln -s /data /app/data

COPY rootfs /
RUN chmod +x /usr/bin/ha-entrypoint.sh

ENTRYPOINT ["/usr/bin/ha-entrypoint.sh"]

# Declaring ENTRYPOINT resets the base image's CMD to empty, so repeat it
# verbatim — nginx (8000) in front of gunicorn (127.0.0.1:8001).
CMD ["gunicorn", "-w", "4", "-k", "uvicorn.workers.UvicornWorker", \
     "--bind", "127.0.0.1:8001", "--timeout", "120", "--keep-alive", "5", \
     "--pid", "/tmp/filaman-gunicorn.pid", "--access-logfile", "-", "app.main:app"]

ARG BUILD_VERSION
LABEL \
    io.hass.type="addon" \
    io.hass.name="FilaMan" \
    io.hass.version="${BUILD_VERSION}" \
    org.opencontainers.image.title="Home Assistant Add-on: FilaMan" \
    org.opencontainers.image.description="Filament management for 3D printing" \
    org.opencontainers.image.source="https://github.com/Fire-Devils/filaman-ha-app" \
    org.opencontainers.image.licenses="MIT"
