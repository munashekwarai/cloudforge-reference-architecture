#!/bin/sh
set -eu
docker compose --profile operations run --rm backup
echo 'Backup created in the managed backups volume; verify restoration before relying on it.'
