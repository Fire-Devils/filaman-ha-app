# Releasing

The add-on version tracks the FilaMan app version. In the normal case you do
nothing here: after an app release, the **Sync app version** workflow picks it
up within a day.

## What the sync does

`.github/workflows/sync-app-version.yml` runs daily at 03:17 UTC and on demand:

1. Reads the latest release of [`Fire-Devils/filaman-system`][app] and skips
   drafts and pre-releases.
2. Compares it with `version:` in `filaman/config.yaml`. Equal → nothing to do.
   Older → the run fails instead of downgrading.
3. Checks that `ghcr.io/fire-devils/filaman-system:<tag>` really exists, so a
   tagged release whose image build failed cannot be published.
4. Bumps `version:` in `filaman/config.yaml` and `ARG FILAMAN_VERSION` in
   `filaman/Dockerfile`, prepends a `filaman/CHANGELOG.md` entry, commits and
   pushes.
5. Starts the **Builder** workflow, which publishes
   `ghcr.io/fire-devils/filaman-addon:<version>` for `aarch64` and `amd64`.

Home Assistant then offers the update, because `version:` in `config.yaml` has
changed.

## Running it by hand

```bash
# pin a specific app release right now
gh workflow run sync-app-version.yml -f tag=v1.3.4

# see what it would change, without committing
gh workflow run sync-app-version.yml -f dry_run=true
```

A push made with `GITHUB_TOKEN` does not start other workflows, which is why
the sync calls the builder explicitly. For the same reason the builder
publishes on `workflow_dispatch` as well — only pull requests build without
pushing an image.

## Add-on-only fixes

For a change that does not follow an app release (a new option, a fix in
`ha-entrypoint.sh`), bump `version:` to a suffixed version by hand and leave
`ARG FILAMAN_VERSION` alone:

```yaml
version: "1.3.3-2"
```

The sync compares only the part before the `-`, so it still bumps to the next
app release.

[app]: https://github.com/Fire-Devils/filaman-system/releases
