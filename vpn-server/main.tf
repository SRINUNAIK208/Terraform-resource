resource "aws_instance" "openvpn" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id = local.public_subnet_id[0]
  availability_zone = local.public_availability_zone[0]
  vpc_security_group_ids = [local.vpn_sg_id]
  key_name = "linux"
  user_data = file("openvpn.sh")

  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-vpn"
    }
  )
}


resource "aws_route53_record" "www" {
  zone_id = var.zone_id
  name    = "vpn-${var.environment}.${var.zone_name}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.openvpn.public_ip]
  allow_overwrite = true
}