resource "digitalocean_ssh_key" "mykey" {
   name = "mykey"
   public_key = file("~/.ssh/id_ed25519.pub")
}

resource "digitalocean_droplet" "web"{
  image   = "ubuntu-24-04-x64"
  name    = "web-1"
  region  = "sgp1"
  size    = "s-1vcpu-1gb"
  ssh_keys = [digitalocean_ssh_key.mykey.id]

  # // Create a SSH connection
  connection {
    type = "ssh"
    user = "root"
    private_key = file("~/.ssh/id_ed25519")
    host = self.ipv4_address
  }

  provisioner "remote-exec" {
    inline = [
        "apt update",
        "apt install nginx -y",
        "systemctl daemon-reload",
        "systemctl enable nginx",
        "systemctl start nginx",
    ]
}

provisioner "file" {
      content = templatefile("./workshop01_nginx_assets/index.html", {
         droplet_ip = self.ipv4_address
      })
      destination = "/var/www/html/index.html"
   }

   provisioner "file" {
      source = "./workshop01_nginx_assets/hello.gif"
      destination = "/var/www/html/hello.gif"
   }
}

output "droplet_ip" {
  value = digitalocean_droplet.web.ipv4_address
}