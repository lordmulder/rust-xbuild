# Rust version
FROM rust:1.91.1-trixie

# Provide the 'install_packages' helper script
COPY bin/install_packages.sh /usr/sbin/install_packages

# Install required dependencies
RUN install_packages \
    clang \
    crossbuild-essential-arm64 \
    crossbuild-essential-i386 \
    crossbuild-essential-ppc64el \
    crossbuild-essential-riscv64 \
    libz3-dev \
    lld \
    musl-tools \
    ruby-dev

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
    rustup component add rust-src

# Install LLVM linker tools
RUN curl -sSf -o /var/tmp/libllvm21.deb http://ftp.debian.org/debian/pool/main/l/llvm-toolchain-21/libllvm21_21.1.4-5_amd64.deb && \
    curl -sSf -o /var/tmp/llvm-21-linker-tools.deb http://ftp.debian.org/debian/pool/main/l/llvm-toolchain-21/llvm-21-linker-tools_21.1.4-5_amd64.deb && \
    curl -sSf -o /var/tmp/libxml2-16.deb http://ftp.debian.org/debian/pool/main/libx/libxml2/libxml2-16_2.15.1+dfsg-0.3_amd64.deb && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y /var/tmp/libxml2-16.deb /var/tmp/libllvm21.deb /var/tmp/llvm-21-linker-tools.deb && \
    rm -f /var/tmp/libxml2-16.deb /var/tmp/libllvm21.deb /var/tmp/llvm-21-linker-tools.deb

# Install "sysroot" for FreeBSD
RUN mkdir -p /opt/sysroot/freebsd/i386 /opt/sysroot/freebsd/amd64 && \
    curl -sSf https://download.freebsd.org/ftp/releases/i386/14.3-RELEASE/base.txz | tar -C /opt/sysroot/freebsd/i386 -xJ ./lib ./usr/lib && \
    curl -sSf https://download.freebsd.org/ftp/releases/amd64/14.3-RELEASE/base.txz | tar -C /opt/sysroot/freebsd/amd64 -xJ ./lib ./usr/lib

# Install "sysroot" for NetBSD
RUN mkdir -p /opt/sysroot/netbsd/amd64 && \
    curl -sSf https://cdn.netbsd.org/pub/NetBSD/NetBSD-10.1/amd64/binary/sets/base.tar.xz | tar -C /opt/sysroot/netbsd/amd64 -xJ ./lib ./usr/lib && \
    curl -sSf https://cdn.netbsd.org/pub/NetBSD/NetBSD-10.1/amd64/binary/sets/comp.tar.xz | tar -C /opt/sysroot/netbsd/amd64 -xJ ./usr/lib

# Install fpm
RUN gem install --no-document fpm && \
    git config --global --add safe.directory '*'

# Set up the 'cargo xbuild' command
COPY bin/cargo-xbuild.sh /usr/local/cargo/bin/cargo-xbuild
