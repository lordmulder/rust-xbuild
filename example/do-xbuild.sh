#!/bin/bash
exec docker run --rm -v "${PWD}":/workspace -w /workspace lordmulder/rust-xbuild cargo xbuild --release
