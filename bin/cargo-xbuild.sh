#!/bin/bash
set -eo pipefail

if [ -z "${RUST_XBUILD_TARGET}" ]; then
    xarch_list=(x86_64-unknown-linux-musl i586-unknown-linux-musl i686-unknown-linux-musl aarch64-unknown-linux-musl)
    xarch_list+=(powerpc64le-unknown-linux-musl riscv64gc-unknown-linux-musl)
    xarch_list+=(x86_64-unknown-freebsd i686-unknown-freebsd x86_64-unknown-netbsd)
else
    xarch_list=(${RUST_XBUILD_TARGET})
fi

if [ ! -z "$1" ] && [ "$1" == "xbuild" ]; then
    shift
fi

for xarch in "${xarch_list[@]}"; do
    case "${xarch}" in
        x86_64-unknown-linux-musl)
            xarch_linker="-Clinker=x86_64-linux-gnu-gcc -Ctarget-feature=+crt-static"
            ;;
        aarch64-unknown-linux-musl)
            xarch_linker="-Clinker=aarch64-linux-gnu-gcc -Ctarget-feature=+crt-static"
            ;;
        powerpc64le-unknown-linux-musl)
            xarch_linker="-Clinker=powerpc64le-linux-gnu-gcc -Ctarget-feature=+crt-static"
            ;;
        i586-unknown-linux-musl)
            xarch_linker="-Clinker=i686-linux-gnu-gcc -Ctarget-feature=+crt-static"
            ;;
        i686-unknown-linux-musl)
            xarch_linker="-Clinker=i686-linux-gnu-gcc -Ctarget-feature=+crt-static"
            ;;
        riscv64gc-unknown-linux-musl)
            xarch_linker="-Clinker=riscv64-linux-gnu-gcc -Ctarget-feature=+crt-static"
            ;;
        i686-unknown-freebsd)
            xarch_linker="-Clinker=clang -Clink-arg=--target=i686-unknown-freebsd -Clink-arg=-fuse-ld=lld -Clink-arg=--sysroot=/opt/sysroot/freebsd/i386 -Ctarget-feature=+crt-static"
            ;;
        x86_64-unknown-freebsd)
            xarch_linker="-Clinker=clang -Clink-arg=--target=x86_64-unknown-freebsd -Clink-arg=-fuse-ld=lld -Clink-arg=--sysroot=/opt/sysroot/freebsd/amd64 -Ctarget-feature=+crt-static"
            ;;
        x86_64-unknown-netbsd)
            xarch_linker="-Clinker=clang -Clink-arg=--target=x86_64-unknown-netbsd -Clink-arg=-fuse-ld=lld -Clink-arg=--sysroot=/opt/sysroot/netbsd/amd64 -Ctarget-feature=+crt-static"
            ;;
        *)
            echo "Unsupported target: \"${xarch}\""
            exit 1
            ;;
    esac

    if [ ! -z "${RUSTFLAGS}" ]; then
        RUSTFLAGS="${RUSTFLAGS} ${xarch_linker}" cargo build --target=${xarch} "$@"
    else
        RUSTFLAGS="${xarch_linker}" cargo build --target=${xarch} "$@"
    fi
done
