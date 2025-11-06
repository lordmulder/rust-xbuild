#!/bin/bash
set -eo pipefail

if [ -z "${RUST_XARCH}" ]; then
    xarch_list=(i586 i686 x86_64 aarch64 powerpc64le riscv64gc)
else
    xarch_list=(${RUST_XARCH})
fi

if [ ! -z "$1" ] && [ "$1" == "xbuild" ]; then
    shift
fi

for xarch in "${xarch_list[@]}"; do
    case "${xarch}" in
        x86_64 | aarch64 | powerpc64le)
            xarch_linker=${xarch}-linux-gnu-gcc
            ;;
        i586 | i686)
            xarch_linker=i686-linux-gnu-gcc
            ;;
        riscv64gc)
            xarch_linker=riscv64-linux-gnu-gcc
            ;;
        *)
            echo "Unsupported architecture: \"${xarch}\""
            exit 1
            ;;
    esac

    if [ ! -z "${RUSTFLAGS}" ]; then
        RUSTFLAGS="${RUSTFLAGS} -Clinker=${xarch_linker}" cargo build --target=${xarch}-unknown-linux-musl "$@"
    else
        RUSTFLAGS="-Clinker=${xarch_linker}" cargo build --target=${xarch}-unknown-linux-musl "$@"
    fi
done
