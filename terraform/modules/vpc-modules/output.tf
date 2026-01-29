output "vpc_id" {
  value = aws_vpc.wtf_vpc.id
}

output "subnet_id" {
  value = aws_subnet.wtf_subnet.id
}