#!/bin/bash

VHOST="$1"

ssh -T root@z13nasserver.srv.company.com <<EOF

  echo "Arreglando propietario de archivos"
  cd /media/hostingsites/${VHOST}/www/htdocs/blog/ || exit 1
  [[ -f wp-config.php ]] || exit 1
  chown ${VHOST}: . -R # Temporal para arreglar los permisos de hostings
  chown anon_${VHOST} wp-content/ wp-admin/ wp-includes/ .htaccess -R
  chmod 775 wp-content/ wp-includes/ -R
  echo "Propietario anon_ y permisos asignados correctamente"

EOF
