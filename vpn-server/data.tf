
data "aws_ami" "openvpn" {
  most_recent = true
  owners = ["679593333241"]

  filter {
    name   = "name"
    values = ["OpenVPN Access Server Community Image-fe8020db-5343-4c43-9e65-5ed4a825c931"]
  }



  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
  data "aws_ssm_parameter" "public_subnet_id" {
    name = "/${var.project}/${var.environment}/public_subnet_id"
  }

   data "aws_ssm_parameter" "public_avalibility_zone" {
    name = "/${var.project}/${var.environment}/public_avalibility_zone"
  }
  data "aws_ssm_parameter" "vpn_sg_id" {
    name = "/${var.project}/${var.environment}/vpn_sg_id"
  }
  


