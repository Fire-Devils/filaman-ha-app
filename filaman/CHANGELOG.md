# Changelog

All notable changes to this add-on are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## 1.3.3

First release of the FilaMan add-on, wrapping FilaMan `v1.3.3`.

- Runs FilaMan on host port `8083` with **OPEN WEB UI** support.
- Add-on options are translated into FilaMan's environment variables, so the
  first administrator, language and log level are configurable from the UI.
- Session and CSRF signing keys are generated per installation on first start
  and kept in `/data/secrets.env`, instead of using the keys baked into the
  published image.
- All FilaMan data (database, backups, uploads, logos, plugins) lives in the
  add-on's persisted `/data` directory.
- The container's own health check on `/health` lets Home Assistant's watchdog
  restart the add-on when FilaMan stops answering.
