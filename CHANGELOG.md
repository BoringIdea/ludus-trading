# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Renamed the project from **ROMA-01** to **Ludus** across the UI, documentation,
  AI prompts, package metadata, and the public API title.
- Repository, clone, issue, and release links now point to
  [BoringIdea/ludus-trading](https://github.com/BoringIdea/ludus-trading).
- Deployment examples now use the `ludus-backend` / `ludus-frontend` service,
  container, and image names.
- The Docker Compose project is now named `ludus`.

### Unchanged (backward compatibility)

- Python package: `roma_trading`
- Distribution name: `roma01`
- Database file: `backend/data/roma_trading.db`
- Log files: `backend/logs/roma_trading_YYYY-MM-DD.log`
- Config auth secret and frontend config token storage key
- ROMA framework attribution in the documentation

### Notes

- This is a branding-only change. There are no functional, schema, or data
  changes, so existing installations require no migration.
- The package name and data file names are retained for now and may be renamed
  in a future major release, together with a migration guide.
