data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project}/${var.environment}/vpc_id"
  
}
data "aws_ssm_parameter" "private_subnet_id" {
    name = "/${var.project}/${var.environment}/private_subnet_id"
  }
data "aws_ssm_parameter" "frontend_sg_id" {
    name = "/${var.project}/${var.environment}/catalogue_sg_id"
  }
data "aws_ssm_parameter" "private_avalibility_zone" {
    name = "/${var.project}/${var.environment}/private_avalibility_zone"
  }

  data "aws_ssm_parameter" "backend_alb_listener_arn" {
    name = "/${var.project}/${var.environment}/backend_alb_listener_arn"
  }

   data "aws_ssm_parameter" "frontend_alb_listener_arn" {
    name = "/${var.project}/${var.environment}/frontend_alb_listener_arn"
  }
data "aws_ami" "joindevops" {
  most_recent = true
  owners = ["973714476881"]

  filter {
    name   = "name"
    values = ["Redhat-9-DevOps-Practice"]
  }



  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}