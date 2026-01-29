locals {
  # normalized workspace name
  environment = terraform.workspace == "default" ? "dev" : terraform.workspace

  # base app/project name
  project     = "wtf"

  # standard prefix pattern for all resources
  prefix      = "${local.project}-${local.environment}"
}


resource "aws_instance" "my_wtf_server" {
  associate_public_ip_address = true
  key_name = aws_key_pair.my_wtf_key.key_name
  instance_type = var.instance_type
  ami = data.aws_ami.my_wtf_ami.id
  subnet_id = var.subnet_id

  region = var.region
  availability_zone =var.az
  vpc_security_group_ids = [aws_security_group.wtf_sg.id]
  user_data = file("ec2-modules/script.sh")
  tags = {
    Name="${local.prefix}-server"
  }
  provisioner "remote-exec" {
  inline = [
    "sudo apt update",
    "sudo apt install -y nginx",
    "sudo systemctl start nginx",
    "echo 'hello everyone' | sudo tee  /var/www/html/index.html",
    "sudo systemctl restart nginx"
  ]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("ec2-modules/my_key")
  }
}
provisioner "file" {
    source = "ec2-modules/script.sh"
    destination = "/home/ubuntu/remote_exec"
    connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("ec2-modules/my_key")
  }
  }

}




resource "aws_key_pair" "my_wtf_key" {
 key_name = "my_wtf_key"
  public_key = file("ec2-modules/my_key.pub")
}

resource "aws_security_group" "wtf_sg" {
  name = "${local.prefix}-sg"
  description = "anything"
  vpc_id =var.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# resource "null_resource" "wtf_null_resource" {
#   provisioner "local-exec" {
  
#     command = "echo Hello World"
#   }
# }

