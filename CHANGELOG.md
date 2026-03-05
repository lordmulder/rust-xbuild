# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 1.94-trixie-r1

### Added

- Link "our" static musl libraries to the Rust `self-contained` directory.

### Changed

- Rust base image updated to version `1.94.0` (2026-03-05).

## 1.93-trixie-r7

### Changed

- Rust base image updated to version `1.93.1` (2026-02-27).

## 1.93-trixie-r6

### Changed

- Rust base image updated to version `1.93.1` (2026-02-25).

## 1.93-trixie-r5

### Changed

- Rust base image updated to version `1.93.1` (2026-02-13).

## 1.93-trixie-r4

### Changed

- Some improvements to how `appimagetool` is added to the image.

## 1.93-trixie-r3

### Changed

- Rust base image updated to version `1.93.0` (2026-02-05).

### Added

- Added `appimagetool` to the image, for easy generation of AppImage files.

### Removed

- Removed the `fpm` tool and `ruby-dev` from the image.

## 1.93-trixie-r2

### Changed

- Rust base image updated to version `1.93.0` (2026-02-03).

### Added

- Included `cargo-edit` tool into the image.

## 1.93-trixie-r1

### Changed

- Rust base image updated to version `1.93.0` (2026-01-22).

## 1.92-trixie-r5

### Changed

- Rust base image updated to version `1.92.0` (2026-01-01).

## 1.92-trixie-r4

### Added

- Build `musl-gcc` for all supported platforms (except for `powerpc64le`)

## 1.92-trixie-r3

### Changed

- Rust base image updated to version `1.92.0` (2025-12-14).

## 1.92-trixie-r2

### Fixed

- Re-added the missing `make` executable to the image.

## 1.92-trixie-r1

### Changed

- Rust base image updated to version `1.92.0`

### Removed

- Dropped 'i686' support FreeBSD, because FreeBSD 15.0 no longer supports it.
