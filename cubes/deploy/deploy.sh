#!/bin/bash

cube_echo "Creating izidict user"
if sudo id izidict; then
  cube_echo "izidict user already exists"
else
  cube_sudo useradd -m -s /bin/bash izidict
fi

cube_echo "Installing izidict postgresql configuration"
cube_expand_parameters < "templates/pg_service.conf" > /tmp/pg_service.conf
cube_sudo mv /tmp/pg_service.conf /home/izidict/.pg_service.conf
cube_sudo chown izidict:izidict /home/izidict/.pg_service.conf
cube_sudo chmod 0600 /home/izidict/.pg_service.conf

cube_echo "Setting up right permissions for the incoming ELM"
cube_sudo chown -R izidict:izidict /var/www/izidict.com
