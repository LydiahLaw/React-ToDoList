output "instance_ip" {
  value = aws_instance.my_wtf_server.public_ip
}

output "ubuntu_ami_id" {
  value = data.aws_ami.my_wtf_ami.id
}
