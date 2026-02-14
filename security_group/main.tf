module "openvpn" {
    source = "../../security-group-module"
    project = var.project
    environment = var.environment
    sg_name = "openvpn"
    sg_des = "creating sg for openvpn"
    vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "openvpn" {
    count            = length(var.vpn_ports)
    type             = "ingress"
    from_port        = var.vpn_ports[count.index]
    to_port          = var.vpn_ports[count.index]
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    security_group_id = module.openvpn.sg_id
    
}

module "mongodb" {
    source = "../../security-group-module"
    project = var.project
    environment = var.environment
    sg_name = "mongodb"
    sg_des = "creating sg for mongodb"
    vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "mongodb_vpn_shh" {
    type             = "ingress"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    source_security_group_id = module.openvpn.sg_id 
    security_group_id = module.mongodb.sg_id
    
}
resource "aws_security_group_rule" "vpn_mongodb" {
    type             = "ingress"
    from_port        = 27017
    to_port          = 27017
    protocol         = "tcp"
    source_security_group_id = module.openvpn.sg_id
    security_group_id = module.mongodb.sg_id
    
}


module "redis" {
    source = "../../security-group-module"
    project = var.project
    environment = var.environment
    sg_name = "redis"
    sg_des = "creating sg for redis"
    vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "redis_vpn_shh" {
    type             = "ingress"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    source_security_group_id = module.openvpn.sg_id 
    security_group_id = module.redis.sg_id
    
}
resource "aws_security_group_rule" "vpn_redis" {
    type             = "ingress"
    from_port        = 6379
    to_port          = 6379
    protocol         = "tcp"
    source_security_group_id = module.openvpn.sg_id
    security_group_id = module.redis.sg_id
    
}
resource "aws_security_group_rule" "user_redis" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id = module.user.sg_id
  security_group_id = module.redis.sg_id
}



module "mysql" {
    source = "../../security-group-module"
    project = var.project
    environment = var.environment
    sg_name = "mysql"
    sg_des = "creating sg for mysql"
    vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "mysql_vpn_shh" {
    type             = "ingress"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    source_security_group_id = module.openvpn.sg_id 
    security_group_id = module.mysql.sg_id
    
}
resource "aws_security_group_rule" "vpn_mysql" {
    type             = "ingress"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    source_security_group_id = module.openvpn.sg_id
    security_group_id = module.mysql.sg_id
    
}
resource "aws_security_group_rule" "shipping_mysql" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.shipping.sg_id
  security_group_id = module.mysql.sg_id
}



module "rabbitmq" {
    source = "../../security-group-module"
    project = var.project
    environment = var.environment
    sg_name = "rabbitmq"
    sg_des = "creating sg for rabbitmq"
    vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "rabbitmq_vpn_shh" {
    type             = "ingress"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    source_security_group_id = module.openvpn.sg_id 
    security_group_id = module.rabbitmq.sg_id
    
}
resource "aws_security_group_rule" "vpn_rabbitmq" {
    type             = "ingress"
    from_port        = 5672
    to_port          = 5672
    protocol         = "tcp"
    source_security_group_id = module.openvpn.sg_id
    security_group_id = module.rabbitmq.sg_id
    
}

resource "aws_security_group_rule" "payment_rabbitmq" {
  type              = "ingress"
  from_port         = 5672
  to_port           = 5672
  protocol          = "tcp"
  source_security_group_id = module.payment.sg_id
  security_group_id = module.rabbitmq.sg_id
}


module "backend_alb" {
    source = "../../security-group-module"
    project = var.project
    environment = var.environment
    sg_name = "backend_alb"
    sg_des = "creating sg for backend_alb"
    vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "vpn_backend_alb" {
    type             = "ingress"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    source_security_group_id = module.openvpn.sg_id 
    security_group_id = module.backend_alb.sg_id
    
}


# resource "aws_security_group_rule" "backend_alb_bastion" {
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   source_security_group_id = module.bastion.sg_id
#   security_group_id = module.backend_alb.sg_id
# }

resource "aws_security_group_rule" "frontend_backend_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend.sg_id
  security_group_id = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "cart_backend_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.cart.sg_id
  security_group_id = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "shipping_backend_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.shipping.sg_id
  security_group_id = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "payment_backend_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.payment.sg_id
  security_group_id = module.backend_alb.sg_id
}



module "catalogue" {
    source = "../../security-group-module"
    project = var.project
    environment = var.environment
    sg_name = "catalogue"
    sg_des = "creating sg for catalogue"
    vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "vpn_catalogue_ssh" {
    type             = "ingress"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    source_security_group_id = module.openvpn.sg_id 
    security_group_id = module.catalogue.sg_id
    
}

resource "aws_security_group_rule" "backend_alb_catalogue" {
    type             = "ingress"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    source_security_group_id = module.backend_alb.sg_id 
    security_group_id = module.catalogue.sg_id
    
}

resource "aws_security_group_rule" "catalogue_mongodb" {
    type             = "ingress"
    from_port        = 27017
    to_port          = 27017
    protocol         = "tcp"
    source_security_group_id = module.catalogue.sg_id 
    security_group_id = module.mongodb.sg_id
    
}


resource "aws_security_group_rule" "catalogue_vpn_http" {
    type             = "ingress"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    source_security_group_id = module.openvpn.sg_id 
    security_group_id = module.catalogue.sg_id
    
}

module "frontend_alb" {
    source = "../../security-group-module"
    project = var.project
    environment = var.environment
    sg_name = "frontend_alb"
    sg_des = "creating sg for frontend_alb"
    vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "frontend_alb_http" {
    type             = "ingress"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.frontend_alb.sg_id
    
}
resource "aws_security_group_rule" "frontend_alb_https" {
    type             = "ingress"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.frontend_alb.sg_id
    
}

module "user" {
    source = "../../security-group-module"
    project = var.project
    environment = var.environment
    sg_name = "user"
    sg_des = "creating sg for user"
    vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "backend_alb_user" {
    type             = "ingress"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    source_security_group_id = module.backend_alb.sg_id 
    security_group_id = module.user.sg_id
    
}

resource "aws_security_group_rule" "user_mongodb" {
    type             = "ingress"
    from_port        = 27017
    to_port          = 27017
    protocol         = "tcp"
    source_security_group_id = module.user.sg_id 
    security_group_id = module.mongodb.sg_id
    
}

resource "aws_security_group_rule" "vpn_shh_user" {
    type             = "ingress"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    source_security_group_id = module.openvpn.sg_id 
    security_group_id = module.user.sg_id
    
}
resource "aws_security_group_rule" "vpn_http_user" {
    type             = "ingress"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    source_security_group_id = module.openvpn.sg_id 
    security_group_id = module.user.sg_id
    
}

module "cart" {
    source = "../../security-group-module"
    project = var.project
    environment = var.environment
    sg_name = "cart"
    sg_des = "creating sg for cart"
    vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "vpn_http_cart" {
    type             = "ingress"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    source_security_group_id = module.openvpn.sg_id 
    security_group_id = module.cart.sg_id
    
}
resource "aws_security_group_rule" "vpn_ssh_cart" {
    type             = "ingress"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    source_security_group_id = module.openvpn.sg_id 
    security_group_id = module.cart.sg_id
    
}
resource "aws_security_group_rule" "cart_redis" {
    type             = "ingress"
    from_port        = 6379
    to_port          = 6379
    protocol         = "tcp"
    source_security_group_id = module.cart.sg_id 
    security_group_id = module.redis.sg_id
    
}
resource "aws_security_group_rule" "backend_alb_cart" {
    type             = "ingress"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    source_security_group_id = module.backend_alb.sg_id 
    security_group_id = module.cart.sg_id
    
}

module "shipping" {
    source = "../../security-group-module"
    project = var.project
    environment = var.environment
    sg_name = "shipping"
    sg_des = "creating sg for shipping"
    vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "vpn_http_shipping" {
    type             = "ingress"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    source_security_group_id = module.openvpn.sg_id 
    security_group_id = module.shipping.sg_id
    
}
resource "aws_security_group_rule" "vpn_ssh_shipping" {
    type             = "ingress"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    source_security_group_id = module.openvpn.sg_id 
    security_group_id = module.shipping.sg_id
    
}

resource "aws_security_group_rule" "backend_alb_shipping" {
    type             = "ingress"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    source_security_group_id = module.backend_alb.sg_id 
    security_group_id = module.shipping.sg_id
    
}


module "payment" {
    source = "../../security-group-module"
    project = var.project
    environment = var.environment
    sg_name = "payment"
    sg_des = "creating sg for payment"
    vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "vpn_http_payment" {
    type             = "ingress"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    source_security_group_id = module.openvpn.sg_id 
    security_group_id = module.payment.sg_id
    
}
resource "aws_security_group_rule" "vpn_ssh_payment" {
    type             = "ingress"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    source_security_group_id = module.openvpn.sg_id 
    security_group_id = module.payment.sg_id
    
}
# resource "aws_security_group_rule" "shipping_rabbitmq" {
#     type             = "ingress"
#     from_port        = 5672
#     to_port          = 5672
#     protocol         = "tcp"
#     source_security_group_id = module.shipping.sg_id 
#     security_group_id = module.rabbitmq.sg_id
    
# }
resource "aws_security_group_rule" "backend_alb_payment" {
    type             = "ingress"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    source_security_group_id = module.backend_alb.sg_id 
    security_group_id = module.payment.sg_id
    
}

module "frontend" {
    source = "../../security-group-module"
    project = var.project
    environment = var.environment
    sg_name = "frontend"
    sg_des = "creating sg for frontend"
    vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "frontend_alb_frontnend" {
    type             = "ingress"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks       = ["10.0.0.0/16"]
    security_group_id = module.frontend.sg_id
    
}
resource "aws_security_group_rule" "vpn_ssh_frontnend" {
    type             = "ingress"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    source_security_group_id = module.openvpn.sg_id 
    security_group_id = module.frontend.sg_id
    
}

                                                                                            