# FilaMan Add-ons for Home Assistant

Home Assistant add-on repository for [FilaMan][filaman], the filament
management system for 3D printing.

## Installation

1. In Home Assistant go to **Settings → Add-ons → Add-on store**.
2. Open the **⋮** menu in the top right, choose **Repositories**.
3. Add this URL:

   ```
   https://github.com/Fire-Devils/filaman-ha-app
   ```

4. Install **FilaMan** from the store, set `admin_email` and `admin_password`
   in the Configuration tab, and start it.

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2FFire-Devils%2Ffilaman-ha-app)

## Add-ons in this repository

| Add-on | Description |
| --- | --- |
| [FilaMan](./filaman) | Spools, printers, AMS slots and RFID tags — the full FilaMan web application |

Requires a Home Assistant installation that supports add-ons (Home Assistant OS
or Supervised) on `amd64` or `aarch64`.

The add-on version tracks the FilaMan app version: a daily workflow pins the
latest app release and publishes the matching add-on image, so Home Assistant
offers the update on its own. See [RELEASING.md](RELEASING.md).

## Support

- Add-on packaging: [issues in this repository](https://github.com/Fire-Devils/filaman-ha-app/issues)
- FilaMan itself: [Fire-Devils/filaman-system](https://github.com/Fire-Devils/filaman-system/issues)
- Manual: [docu.filaman.app](https://docu.filaman.app)

## License

MIT — see [LICENSE](LICENSE).

[filaman]: https://github.com/Fire-Devils/filaman-system
