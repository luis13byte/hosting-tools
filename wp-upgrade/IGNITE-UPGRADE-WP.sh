#!/bin/bash

VHOST="$1"

./01-backup-db-htdocs.sh ${VHOST} && \
./02-fix-owner-permissions.sh ${VHOST} && \
./03-upgrade-wordpress.sh ${VHOST} && \
echo "El sitio Wordpress ${VHOST} ha sido actualizado"
