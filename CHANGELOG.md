# Changelog

## [0.1.0-beta.1-wip]

### Added

- Initial release.
- `tracedQonversion<T>(...)` — wraps a otel_qonversion call in a CLIENT-kind span
  with vendor-specific attributes.
- Zone-scoped suppression via `runWithoutQonversionInstrumentation()` / `Async()`.
