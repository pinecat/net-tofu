# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.0] - 2023-07-29

### Fixed

- Renamed the library to something more appropriate `opentofu -> net-tofu`.
- Fixed Github workflows.
- Using my fork of the `gemtext` gem, until my PR is finialized.

## [0.2.0] - 2023-07-29

### Added

- Certificate checking and pinning logic.
- Tests for certificate and pinning logic.

### Fixed

- Tests involving fetching data, as they need to trust the host now.

## [0.1.1] - 2023-07-28

### Added

- Tests.
- The `simplecov` gem to view testing coverage.
- A new error, for if the server doesn't send any data.
- The Linux platform to the bundle platform.

### Fixed

- Complexity issues in the Response class from the linter.

### Removed

- The `@@current_host` class variable from Request. Clients should handle keeping track of the current host, Tofu should just fetch data.
- The complicated logic used to parse host names from the Request class, as per the above point.

## [0.1.0] - 2023-07-27

First release. Still lots of improvements to be made.

### Added

- Custom error classes for the library.
- A Request model for handling client requests.
  - Handles the URI parsing logic.
  - Holds a Response type.
  - Does some basic error checking based on the Gemini Protocol specification.
- A Response model for handling server responses.
  - Holds a Socket type.
  - Does some basic error checking based on the Gemini Protocol specification.
- A Socket model for handling raw socket connections, as well as TLS security settings.
- A top-level module for making get and get_response requests.
- Added a 'trust' parameter to the Net::Tofu.get and Net::Tofu.get_response methods. This will later be used for certificate management, but it isn't in use yet.