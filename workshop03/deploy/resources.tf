# resource "digitalocean_ssh_key" "mykey" {
#    name = "mykey"
#    public_key = file("~/.ssh/id_ed25519.pub")
# }

data "digitalocean_ssh_key" "mykey" {
  name = "mykey"
}

data "digitalocean_image" "packer_snapshot" {
  name = "my-codeserver"
}

resource "digitalocean_droplet" "codeserver"{
  image   = data.digitalocean_image.packer_snapshot.id
  name    = "workshop-3"
  region  = "sgp1"
  size    = "s-2vcpu-4gb"
  #ssh_keys = [digitalocean_ssh_key.mykey.id]
  ssh_keys = [data.digitalocean_ssh_key.mykey.fingerprint]

  # // Create a SSH connection
  connection {
    type = "ssh"
    user = "root"
    private_key = file(var.ssh_private_key_path)
    host = self.ipv4_address
  }

}

resource "local_file" "inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    droplet_ip             = digitalocean_droplet.codeserver.ipv4_address
    ansible_user           = var.ansible_user
    ssh_private_key_path   = var.ssh_private_key_path
    codeserver_password = var.codeserver_password
  })
  filename = "${path.module}/inventory.yaml"
}

output "droplet_ip" {
  value = digitalocean_droplet.codeserver.ipv4_address
}