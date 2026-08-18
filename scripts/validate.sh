#!/bin/sh
set -eu
terraform fmt -check -recursive terraform
terraform -chdir=terraform/environments/local init -backend=false
terraform -chdir=terraform/environments/local validate
terraform -chdir=terraform init -backend=false
terraform -chdir=terraform test
docker compose config --quiet
python -m pytest -q
