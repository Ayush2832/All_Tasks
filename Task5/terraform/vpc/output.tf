output "vpc" {
    description = "VPC id is"
    value = aws_vpc.main.id
}

output "subnet" {
    description = "Subnet id is"
    value = aws_subnet.main.id
}