all:
  children:
    codeserver:
      hosts:
        ${droplet_ip}:
          ansible_user: ${ansible_user}
          ansible_ssh_private_key_file: ${ssh_private_key_path}
      vars:
        code_server_password: ${codeserver_password}