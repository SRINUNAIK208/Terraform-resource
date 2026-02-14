locals {
    ami_id = data.aws_ami.openvpn.id
    public_subnet_id = split(",", data.aws_ssm_parameter.public_subnet_id.value)
    public_availability_zone = split(",",data.aws_ssm_parameter.public_avalibility_zone.value)
    common_tags = {
        project = var.project
        environment = var.environment
        terraform = true
    }
    vpn_sg_id = data.aws_ssm_parameter.vpn_sg_id.value
}