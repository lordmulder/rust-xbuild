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


The "xbuild" script
-------------------

The [`cargo-xbuild`](bin/cargo-xbuild.sh) helper script is provided to make cross-building slightly easier 😅

Just run the following command from your Rust project directory:
```sh
cargo xbuild --release
```

By default, this script will build *all* supported platforms.

The environment variable `RUST_XARCH` can be used to specify the platforms to build.


Docker integration
------------------

To build your project with `cargo-xbuild` inside the Docker container:

```sh
docker run --rm -v /path/to/source:/workspace -w /workspace \
lordmulder/rust-xbuild cargo xbuild --release
```


Manual usage
------------

Alternatively, you can manually set up the desired `--target` for Rust:

* **`i586-unknown-linux-musl`** toolchain:
  ```sh
  export RUSTFLAGS="-Clinker=i686-linux-gnu-gcc"
  cargo build --release --target i586-unknown-linux-musl
  ```

* **`aarch64-unknown-linux-musl`** toolchain:
  ```sh
  export RUSTFLAGS="-Clinker=aarch64-linux-gnu-gcc"
  cargo build --release --target aarch64-unknown-linux-musl
  ```

* **`powerpc64le-unknown-linux-musl`** toolchain:
  ```sh
  export RUSTFLAGS="-Clinker=powerpc64le-linux-gnu-gcc"
  cargo build --release --target powerpc64le-unknown-linux-musl
  ```

* **`riscv64gc-unknown-linux-musl`** toolchain:
  ```sh
  export RUSTFLAGS="-Clinker=riscv64-linux-gnu-gcc"
  cargo build --release --target riscv64gc-unknown-linux-musl
  ```