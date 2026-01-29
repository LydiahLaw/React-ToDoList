output "instance_ip" {
  value = module.ec2-modules.instance_ip
}

output "server_ami_id" {
  value = module.ec2-modules.ubuntu_ami_id
}