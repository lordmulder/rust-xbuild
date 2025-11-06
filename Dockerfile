# Rust version
FROM rust:1.91-trixie

# Provide the 'install_packages' helper script
COPY bin/install_packages.sh /usr/sbin/install_packages

# Install required dependencies
RUN install_packages \
    musl-tools \
    crossbuild-essential-i386 \
    crossbuild-essential-arm64 \
    crossbuild-essential-riscv64 \
    crossbuild-essential-ppc64el \
    ruby-dev \
    libz3-dev

# Install Rust targets
RUN rustup target add aarch64-unknown-linux-musl && \
    rustup target add i586-unknown-linux-musl && \
    rustup target add i686-unknown-linux-musl && \
    rustup target add powerpc64le-unknown-linux-musl && \
    rustup target add riscv64gc-unknown-linux-musl && \
    rustup target add x86_64-unknown-linux-musl && \
    rustup component add rustfmt && \
    rustup component add rust-src

# Set up the 'cargo xbuild' command
COPY bin/cargo-xbuild.sh /usr/local/cargo/bin/cargo-xbuild

# Install LLVM linker tools
RUN curl -sSf -o /var/tmp/libllvm21.deb http://ftp.debian.org/debian/pool/main/l/llvm-toolchain-21/libllvm21_21.1.4-5_amd64.deb && \
    curl -sSf -o /var/tmp/llvm-21-linker-tools.deb http://ftp.debian.org/debian/pool/main/l/llvm-toolchain-21/llvm-21-linker-tools_21.1.4-5_amd64.deb && \
    curl -sSf -o /var/tmp/libxml2-16.deb http://ftp.debian.org/debian/pool/main/libx/libxml2/libxml2-16_2.15.1+dfsg-0.3_amd64.deb && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y /var/tmp/libxml2-16.deb /var/tmp/libllvm21.deb /var/tmp/llvm-21-linker-tools.deb && \
    rm -f /var/tmp/libxml2-16.deb /var/tmp/libllvm21.deb /var/tmp/llvm-21-linker-tools.deb

# Install fpm
RUN gem install --no-document fpm && \
    git config --global --add safe.directory '*'
