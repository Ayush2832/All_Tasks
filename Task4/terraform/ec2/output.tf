output "public_ip" {
    description = "Instance ip "
    value = aws_instance.strapi_ec2.public_ip
}

output "strapiapp" {
  description = "Strapi app running on this link"
  value = "http://${aws_instance.strapi_ec2.public_ip}:1337"
}