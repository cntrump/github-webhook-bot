#!/usr/bin/env sh

set -e

swift build -c release \
            -Xswiftc -static-stdlib \
            -Xswiftc -Xfrontend \
            -Xswiftc -enable-copy-propagation
