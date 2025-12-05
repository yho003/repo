variable DO_TOKEN {
   type = string 
   sensitive = true
}

variable codeserver_password {
   type = string
   sensitive = true
}

variable ssh_private_key_path {
   type = string
   sensitive = true
}

variable ansible_user {
   type = string
   default = "root"
}