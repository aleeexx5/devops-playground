output "instance_id" {
  value = aws_instance.web.id
}
output "ip_privada" {
  value = aws_instance.web.private_ip
}