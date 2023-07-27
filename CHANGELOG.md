# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2023-07027

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