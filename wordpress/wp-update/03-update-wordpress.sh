#!/bin/bash

VHOST="$1"
PLUGINEXCLUDED="--exclude=easyreservations" # Ej: --exclude=easyreservations

ssh -T ${VHOST}@z13sshjail.srv.company.com <<'EOF'

  # Parte 2: Wordpress upgrade

  echo "Cambiando los permisos.."
  /opt/tools/enablePermissiveMode.sh 2>/dev/null
  cd /www/htdocs/blog/ || exit 1
  [[ $(ls -la wp-content/plugins | head -n2 | tail -n1 | cut -d "." -f1 ) = "drwxrwxr-x" ]] || { echo "Los permisos podrían ser incorrectos" ;exit 1; }
  [[ $(ls -la wp-includes/ | head -n2 | tail -n1 | cut -d "." -f1 ) = "drwxrwxr-x" ]] || { echo "Los permisos podrían ser incorrectos" ;exit 1; }

  echo -e "\nINICIANDO UPGRADES, con WP-CLI"
  /bin/wp cli version > /dev/null || { echo "El binario de WP-CLI no esta funcionando" ;exit 1; }
  /bin/wp plugin update --all ${PLUGINEXCLUDED}
  /bin/wp theme update --all
  /bin/wp core update && /bin/wp core update-db
  /bin/wp language core update
  echo "WP CORE VERSION NOW: $(/bin/wp core version)"
  /bin/wp cache flush

  # Restablecer permisos
  echo -e "\nRestableciendo los permisos originales.."
  /opt/tools/disablePermissiveMode.sh 2> /dev/null

EOF
