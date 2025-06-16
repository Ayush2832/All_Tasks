output "vpc" {
    description = "VPC id is"
    value = aws_vpc.main.id
}

output "subnet" {
    description = "subnet id is"
    value = aws_subnet.main.id
  
}