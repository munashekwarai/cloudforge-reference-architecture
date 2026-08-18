#!/bin/sh
set -eu
umask 077
mkdir -p .secrets
[ -s .secrets/db_password ] || openssl rand -base64 36 > .secrets/db_password
[ -s .secrets/tls.key ] || openssl req -x509 -newkey rsa:3072 -sha256 -nodes -days 30 -subj '/CN=localhost' -addext 'subjectAltName=DNS:localhost,IP:127.0.0.1' -keyout .secrets/tls.key -out .secrets/tls.crt
printf '*:*:*:app:%s\n' "$(cat .secrets/db_password)" > .secrets/pgpass
chmod 600 .secrets/*
echo 'Local-only secrets created in ignored .secrets/'
