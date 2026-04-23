# Version
ARG MY_RUST_VERS=1.95.0
ARG MY_RUST_HASH=c03ea1587a8e4474ae1a3f4a377cbb35ad53d2eb5c27f0bdf1ca8986025e322f

# Rust version
FROM rust:${MY_RUST_VERS}-slim-trixie@sha256:${MY_RUST_HASH}

# Provide the 'install_packages' helper script
COPY bin/install_packages.sh /usr/sbin/install_packages

# Install required dependencies
RUN install_packages \
    clang \
    crossbuild-essential-arm64 \
    crossbuild-essential-i386 \
    crossbuild-essential-ppc64el \
    crossbuild-essential-riscv64 \
    curl \
    file \
    git \
    libz3-dev \
    lld \
    make \
    musl-tools \
    pandoc \
    xz-utils

# Install Rust targets
RUN rustup target add aarch64-unknown-linux-musl && \
    rustup target add i586-unknown-linux-musl && \
    rustup target add i686-unknown-freebsd && \
    rustup target add i686-unknown-linux-musl && \
    rustup target add powerpc64le-unknown-linux-musl && \
    rustup target add riscv64gc-unknown-linux-musl && \
    rustup target add x86_64-unknown-freebsd && \
    rustup target add x86_64-unknown-linux-musl && \
    rustup target add x86_64-unknown-netbsd && \
    rustup component add rustfmt && \
    rustup component add clippy && \
    rustup component add rust-src

# Install cargo-edit
RUN cargo install cargo-edit && \
    rm -rf /usr/local/cargo/.global-cache /usr/local/cargo/.package-cache /usr/local/cargo/.package-cache-mutate /usr/local/cargo/registry

# Install LLVM linker tools
RUN curl -sSf -o /var/tmp/libllvm22.deb http://ftp.debian.org/debian/pool/main/l/llvm-toolchain-22/libllvm22_22.1.3-1+b1_amd64.deb && \
    curl -sSf -o /var/tmp/llvm-22-linker-tools.deb http://ftp.debian.org/debian/pool/main/l/llvm-toolchain-22/llvm-22-linker-tools_22.1.3-1+b1_amd64.deb && \
    curl -sSf -o /var/tmp/libxml2-16.deb http://ftp.debian.org/debian/pool/main/libx/libxml2/libxml2-16_2.15.2+dfsg-0.1_amd64.deb && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y /var/tmp/libxml2-16.deb /var/tmp/libllvm22.deb /var/tmp/llvm-22-linker-tools.deb && \
    rm -f /var/tmp/libxml2-16.deb /var/tmp/libllvm22.deb /var/tmp/llvm-22-linker-tools.deb

# Install "sysroot" for FreeBSD
RUN mkdir -p /opt/sysroot/freebsd/i386 /opt/sysroot/freebsd/amd64 && \
    curl -sSf https://download.freebsd.org/ftp/releases/amd64/15.0-RELEASE/base.txz | tar -C /opt/sysroot/freebsd/amd64 -xJ ./lib ./usr/lib && \
    curl -sSf https://download.freebsd.org/ftp/releases/i386/14.3-RELEASE/base.txz  | tar -C /opt/sysroot/freebsd/i386  -xJ ./lib ./usr/lib

# Install "sysroot" for NetBSD
RUN mkdir -p /opt/sysroot/netbsd/amd64 && \
    curl -sSf https://cdn.netbsd.org/pub/NetBSD/NetBSD-10.1/amd64/binary/sets/base.tar.xz | tar -C /opt/sysroot/netbsd/amd64 -xJ ./lib ./usr/lib && \
    curl -sSf https://cdn.netbsd.org/pub/NetBSD/NetBSD-10.1/amd64/binary/sets/comp.tar.xz | tar -C /opt/sysroot/netbsd/amd64 -xJ ./usr/lib

# Build musl libc for all supported targets
ARG MY_RUST_VERS
RUN curl -vkf -o /tmp/musl-latest.tar.gz https://musl.libc.org/releases/musl-latest.tar.gz && \
    for target_host in i686 x86_64 aarch64 riscv64; do \
        mkdir -p /tmp/musl-build-${target_host} && \
        tar -xvf /tmp/musl-latest.tar.gz --strip-components=1 -C /tmp/musl-build-${target_host} && \
        cd /tmp/musl-build-${target_host} && \
        ./configure --disable-shared --enable-static --prefix=/usr/local/musl/${target_host} --host=${target_host}-linux-gnu --enable-optimize="*" && \
        sed -i 's|-fPIC|-fomit-frame-pointer|g' Makefile && \
        make && make install && \
        ln -snf /usr/local/musl/${target_host}/lib/*.a /usr/local/musl/${target_host}/lib/*.o /usr/local/rustup/toolchains/${MY_RUST_VERS}-x86_64-unknown-linux-gnu/lib/rustlib/$([ "${target_host}" = "riscv64" ] && echo "${target_host}gc" || echo "${target_host}")-unknown-linux-musl/lib/self-contained/ && \
        cd /tmp && rm -rf musl-build-${target_host}; \
    done && \
    rm -f /tmp/musl-latest.tar.gz

# Install AppImage tool
RUN mkdir -p /opt/appimage/runtimes && \
    curl -Lfo /opt/appimage/appimagetool.AppImage https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage && \
    chmod 555 /opt/appimage/appimagetool.AppImage && \
    for arch in i686 x86_64 armhf aarch64; do \
        curl -Lfo /opt/appimage/runtimes/runtime-$arch https://github.com/AppImage/type2-runtime/releases/download/continuous/runtime-$arch && \
        chmod 555 /opt/appimage/runtimes/runtime-$arch; \
    done && \
    git config --global --add safe.directory '*'

# Workaround to make appimagetool.AppImage work inside of Docker
ENV APPIMAGE_EXTRACT_AND_RUN=1

# Set up the 'cargo xbuild' command
COPY bin/cargo-xbuild.sh /usr/local/cargo/bin/cargo-xbuild
