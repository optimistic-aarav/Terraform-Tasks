provider "aws" {
  region = "us-east-1"
  access_key = "<YOUR ACCESS KEY HERE>"
  secret_key = "<YOUR SECRET KEY HERE>"
}

resource "aws_key_pair" "key" {
  key_name   = "private_key"
  public_key = file(var.public_key)
}


resource "aws_instance" "testvm" {
  ami = "ami-0885b1f6bd170450c"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.websg.id ]
      tags = {
      Name = Test-VM"
    }
}

resource "aws_security_group" "testsg" {
  name = test-sg01"
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP1"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_eip" "tf_key" {
  vpc      = true
  instance = aws_instance.testvm.id
}


provisioner "remote-exec" {
    inline = ["sudo apt update", "sudo apt install python3 -y", "sudo apt install ansible -y", "echo Done!"]

    connection {
        type        = "ssh"
        user        = "ubuntu"
        host        = "${self.ipv4_address}"
        private_key = "${file(var.private_key)}"
    }
}

provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${self.ipv4_address},' --private-key ${var.private_key}  nginix-install.yml"
  }

provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${self.ipv4_address},' --private-key ${var.private_key}  docker-install.yml"
  }
