output "ec2" {
    description = "EC2 ip is"
    value = aws_instance.strapi_ec2.public_ip
}

output "strapi" {
    description = "Strapi container running on"
    value = "http://${aws_instance.strapi_ec2.public_ip}:1337"
}