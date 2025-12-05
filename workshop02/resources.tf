# resource "digitalocean_ssh_key" "mykey" {
#    name = "mykey"
#    public_key = file("~/.ssh/id_ed25519.pub")
# }

data "digitalocean_ssh_key" "mykey" {
  name = "mykey"
}

resource "digitalocean_droplet" "web"{
  image   = "ubuntu-24-04-x64"
  name    = "workshop-2"
  region  = "sgp1"
  size    = "s-2vcpu-4gb"
  #ssh_keys = [digitalocean_ssh_key.mykey.id]
  ssh_keys = [data.digitalocean_ssh_key.mykey.id]

  # // Create a SSH connection
  connection {
    type = "ssh"
    user = "root"
    private_key = file("~/.ssh/id_ed25519")
    host = self.ipv4_address
  }

}

output "droplet_ip" {
  value = digitalocean_droplet.web.ipv4_address
}