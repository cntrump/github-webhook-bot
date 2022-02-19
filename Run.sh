#!/usr/bin/env sh

set -e

app_path=`swift build -c release --show-bin-path`
app=$app_path/Run

$app serve --env production --hostname 0.0.0.0 --port 8080

