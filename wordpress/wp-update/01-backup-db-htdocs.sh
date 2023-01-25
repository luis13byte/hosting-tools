#!/bin/bash

VHOST="$1"

ssh -T ${VHOST}@z13sshjail.srv.company.com <<'EOF'

  # Parte 1: Backups de base de datos y htdocs

  echo "Haciendo backup de htdocs.."
  cd /opt/tools/ || exit
  ./Upgrade-backup-htdocs.sh || { echo "ERR: Backup de htdocs fallido" ;exit; }
  [[ $(du -s /backup/*.tar.gz | awk '{print $1}') -gt 300 ]] || { echo "El backup htdocs es incorrecto" ;exit 1; }

  echo "Haciendo backup de base de datos.."
  ./Upgrade-backup-db.sh
  [[ $(du -s /backup/*.bz2 | awk '{print $1}') -gt 70 ]] || { echo "El backup base de datos es incorrecto" ;exit 1; }

EOF
