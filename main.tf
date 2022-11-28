locals {
  vpc_id           = "vpc-0fd064b5f57a23ae1"
  subnet_id        = "subnet-023f667fa7a50d0d9"
  ssh_user         = "ubuntu"
  key_name         = "devops"
  private_key_path = "/home/ubuntu/key/devops.pem"
}


resource "aws_security_group" "nginx" {
  name   = "nginx_access"
  vpc_id = local.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_instance" "nginx" {
  ami                         = "ami-09b18720cb71042df"
  subnet_id                   = "subnet-023f667fa7a50d0d9"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.nginx.id]
  key_name                    = local.key_name
  tags = {
    Name = "Terraform Ec2"
  }

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = file(local.private_key_path)
      host        = aws_instance.nginx.public_ip
    }
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.nginx.public_ip}, --private-key ${local.private_key_path} apache.yaml"
  }
}

output "nginx_ip" {
  value = aws_instance.nginx.public_ip
}
