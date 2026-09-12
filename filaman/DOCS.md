# Home Assistant Add-on: FilaMan

## Installation

1. Add this repository to the add-on store: **Settings → Add-ons → Add-on store
   → ⋮ → Repositories**, then paste
   `https://github.com/Fire-Devils/filaman-ha-app`.
2. Install **FilaMan** from the store.
3. Open the **Configuration** tab and set at least `admin_email` and
   `admin_password` — without both, no user is created and you cannot log in.
4. Start the add-on, then use **OPEN WEB UI** (port `8083` by default).

## Configuration

```yaml
admin_email: you@example.com
admin_password: choose-something-long
admin_display_name: Manuel
admin_language: en
log_level: info
```

| Option | Required | Description |
| --- | --- | --- |
| `admin_email` | yes | E-mail of the first administrator. Used as the login name. |
| `admin_password` | yes | Password for that account. Only applied when the account is created. |
| `admin_display_name` | no | Name shown in the interface. Defaults to the e-mail. |
| `admin_language` | no | Interface language for the first account: `en` or `de`. |
| `log_level` | no | `debug`, `info`, `warning` or `error`. |
| `cors_origins` | no | Extra origins allowed to call the API, comma separated. Leave empty unless you embed FilaMan elsewhere. |
| `filamentdb_url` | no | Override the filament database used for lookups. Default: `https://db.filaman.app`. |

### Changing the admin password later

`admin_password` is only read when the account is **created**. Changing it
afterwards has no effect — change it in the interface under your profile, or
reset it from a terminal:

```bash
docker exec -it addon_filaman python -m app.cli reset-password you@example.com
```

## Ports

The add-on publishes port `8000` of the container on host port `8083`. Change
the host port in the **Network** section of the add-on if `8083` is taken.

FilaMan is not available in the Home Assistant sidebar yet: its web interface
currently needs to run at the root of a host, which Ingress cannot provide.
Ingress support is tracked in the main repository.

## Where your data lives

Everything persists in the add-on's `/data` directory, which survives updates
and restarts:

- `filaman.db` — the SQLite database
- `backups/` — nightly database backups (kept by the container's cron job)
- `uploads/`, `logos/` — uploaded images and manufacturer logos
- `plugins/` — installed printer plugins
- `secrets.env` — session and CSRF signing keys, generated on first start

To reach these files, install the **Samba share** or **Advanced SSH & Web
Terminal** add-on and look under `/mnt/data/supervisor/addons/data/`.

A database migration runs automatically on every start, and the container takes
a backup first.

## Updating

Update the add-on from the add-on store as usual. `/data` is kept, migrations
run on start. Downgrading is not supported once a migration has run — restore a
backup from `backups/` instead.

## Troubleshooting

**„Invalid credentials" on the first login**
`admin_email`/`admin_password` were probably empty on the first start, so no
account exists. Set both, then restart — if the log still says nothing was
seeded, the database already holds a different account; use the reset command
above.

**Too many login attempts**
The container rate-limits logins to 10 per minute per client IP. Wait a minute.

**The add-on keeps restarting**
With the add-on's *Watchdog* switch on, Home Assistant restarts FilaMan when the
container's health check (`/health`) stops answering. Check the add-on log for
the real error, usually a failed migration.

## Support

- Add-on issues: https://github.com/Fire-Devils/filaman-ha-app/issues
- FilaMan itself: https://github.com/Fire-Devils/filaman-system/issues
- Manual: https://docu.filaman.app

## License

MIT, same as FilaMan itself. See [LICENSE](../LICENSE).
