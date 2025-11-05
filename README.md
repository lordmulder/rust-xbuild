Rust Cross-Build
================

Docker container with [Rust](https://hub.docker.com/_/rust) and Debian cross-build utilities.

**Docker Hub page:**  
<https://hub.docker.com/r/lordmulder/rust-xbuild>


Supported toolchains
--------------------

- `aarch64-unknown-linux-musl`
- `i586-unknown-linux-musl`
- `i686-unknown-linux-musl`
- `powerpc64le-unknown-linux-musl`
- `riscv64gc-unknown-linux-musl`
- `x86_64-unknown-linux-musl`


Usage example
-------------

* The **`i586-unknown-linux-musl`** toolchain can be used like this:
  ```sh
  export RUSTFLAGS="-Clinker=i686-linux-gnu-gcc"
  cargo build --release --target i586-unknown-linux-musl
  ```

* The **`aarch64-unknown-linux-musl`** toolchain can be used like this:
  ```sh
  export RUSTFLAGS="-Clinker=aarch64-linux-gnu-gcc"
  cargo build --release --target aarch64-unknown-linux-musl
  ```

* The **`powerpc64le-unknown-linux-musl`** toolchain can be used like this:
  ```sh
  export RUSTFLAGS="-Clinker=powerpc64le-linux-gnu-gcc"
  cargo build --release --target powerpc64le-unknown-linux-musl
  ```

* The **`riscv64gc-unknown-linux-musl`** toolchain can be used like this:
  ```sh
  export RUSTFLAGS="-Clinker=riscv64-linux-gnu-gcc"
  cargo build --release --target riscv64gc-unknown-linux-musl
  ```