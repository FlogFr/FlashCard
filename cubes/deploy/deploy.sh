#!/bin/bash

source ./helpers.sh

cube_create_user "izidict" ""

cube_echo "Installing izidict postgresql configuration"
cube_expand_parameters < "templates/pg_service.conf" > /tmp/pg_service.conf
cube_sudo mv /tmp/pg_service.conf /home/izidict/.pg_service.conf
cube_sudo chown izidict:izidict /home/izidict/.pg_service.conf
cube_sudo chmod 0600 /home/izidict/.pg_service.conf

TEMP_FILE=$(mktemp)
cube_expand_parameters < "templates/vhost.tpl" > "${TEMP_FILE}"
cube_sudo cp "${TEMP_FILE}" "/etc/nginx/conf.d/${DOMAIN}.conf"
# restart nginx
cube_sudo nginx -t >/dev/null 2>&1 || cube_check_return
cube_sudo systemctl reload nginx

cube_echo "Setting up right permissions for the incoming ELM"
cube_sudo mkdir -p /var/www/izidict.com
cube_sudo chown -R izidict:izidict /var/www/izidict.com
