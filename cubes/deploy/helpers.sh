#!/bin/bash

function cube_create_user () {
  user="$1"
  export ssh_authorized_key="${2:-}"

  cube_echo "Creating ${user} unix user"
  if sudo id "${user}"; then
    cube_echo "${user} user already exists"
  else
    cube_sudo useradd -m -s /bin/bash "${user}"
    cube_sudo sudo -u "${user}" -- mkdir -p "/home/${user}/.ssh"
    TMP_FILE=$(mktemp)
    cube_expand_parameters < "templates/authorized_keys" > "${TMP_FILE}"
    cube_sudo mv "${TMP_FILE}" "/home/${user}/.ssh/authorized_keys"
    cube_sudo chown "${user}":"${user}" "/home/${user}/.ssh/authorized_keys"
    cube_sudo chmod 0640 "/home/${user}/.ssh/authorized_keys"
  fi
}
