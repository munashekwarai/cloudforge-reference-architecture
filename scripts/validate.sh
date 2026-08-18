#!/bin/sh
set -eu
terraform -chdir=terraform/environments/local fmt -check
terraform -chdir=terraform/environments/local init -backend=false
terraform -chdir=terraform/environments/local validate
docker compose config --quiet
