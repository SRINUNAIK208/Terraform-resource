locals{
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    ami_id = data.aws_ami.joindevops.id
    private_subnet_id = split(",", data.aws_ssm_parameter.private_subnet_id.value)
    private_availability_zone = split(",",data.aws_ssm_parameter.private_avalibility_zone.value)
    backend_alb_listener_arn = data.aws_ssm_parameter.backend_alb_listener_arn.value
    catalogue_sg_id = data.aws_ssm_parameter.catalogue_sg_id.value
    common_tags = {
        project = var.project
        environment = var.environment
        terraform = true
    }
}
