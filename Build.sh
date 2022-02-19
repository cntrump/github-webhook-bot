#!/usr/bin/env sh

set -e

swift build -c release -Xswiftc -static-stdlib

