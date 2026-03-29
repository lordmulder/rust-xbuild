#!/bin/bash
exec docker run --rm -v "${PWD}":/workspace -w /workspace lordmulder/rust-xbuild:latest cargo xbuild --release
