resource "aws_lb_target_group" "frontend" {
  name     = "${var.project}-${var.environment}-frontend"
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.vpc_id


  health_check {
    healthy_threshold = 2
    interval = 7
    matcher = "200-299"
    path = "/"
    port = 80
    timeout = 5
    unhealthy_threshold = 3
  }

}

    
resource "aws_instance" "frontend" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id = local.private_subnet_id[0]
  vpc_security_group_ids = [local.frontend_sg_id]
 


  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-frontend"
    }
  )
}

resource "terraform_data" "frontend" {
  triggers_replace = [
    aws_instance.frontend.id
  ]

  provisioner "file"{
    source = "frontend.sh"
    destination = "/tmp/frontend.sh"
  }
    connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.frontend.private_ip
  }


  provisioner "remote-exec"{
    inline = [
        "chmod +x /tmp/frontend.sh",
        "sudo sh /tmp/frontend.sh frontend ${var.environment}"
    ]
  }
}

resource "aws_ec2_instance_state" "frontend" {
  instance_id  = aws_instance.frontend.id
  state       = "stopped"
  depends_on = [terraform_data.frontend]
}

resource "aws_ami_from_instance" "frontend" {
  name               = "${var.project}-${var.environment}-frontend"
  source_instance_id = aws_instance.frontend.id
  depends_on = [aws_ec2_instance_state.frontend]
   tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-frontend"
    }
  )
  
}


resource "terraform_data" "frontend_delete" {
  triggers_replace = [
    aws_instance.frontend.id
  ]

  provisioner "local-exec"{
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.frontend.id}"
  }
  depends_on = [aws_ami_from_instance.frontend]
}

resource "aws_launch_template" "frontend" {
  name = "${var.project}-${var.environment}-frontend"
  image_id = aws_ami_from_instance.frontend.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.frontend_sg_id]
  update_default_version = true
  tag_specifications {
    resource_type = "instance"

    tags = merge(
        local.common_tags,
        {
           Name= "${var.project}-${var.environment}-frontend"
        }
    )
  }
  tag_specifications {
    resource_type = "volume"

    tags = merge(
        local.common_tags,
        {
           Name= "${var.project}-${var.environment}-frontend"
        }
    )
  }
   
   tags = merge(
        local.common_tags,
        {
           Name= "${var.project}-${var.environment}-frontend"
        }
    )
  
}
resource "aws_autoscaling_group" "frontend" {
   name                 = "${var.project}-${var.environment}-frontend"
  desired_capacity   = 1
  max_size           = 5
  min_size           = 1
 target_group_arns = [aws_lb_target_group.frontend.arn]
  vpc_zone_identifier  = local.private_subnet_id
  health_check_grace_period = 90
  health_check_type         = "ELB"

  launch_template {
    id      = aws_launch_template.frontend.id
    version = aws_launch_template.frontend.latest_version
  }

   dynamic "tag" {
    for_each = merge(
      local.common_tags,
      {
        Name = "${var.project}-${var.environment}-frontend"
      }
    )
    content{
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
    
  }
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }
   timeouts{
    delete = "15m"
  }
}

resource "aws_autoscaling_policy" "frontend" {
  name                   = "${var.project}-${var.environment}-frontend"
  autoscaling_group_name = aws_autoscaling_group.frontend.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 75.0
  }
}

resource "aws_lb_listener_rule" "frontend" {
  listener_arn = local.frontend_alb_listener_arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }

  condition {
    host_header {
      values = ["${var.environment}.${var.zone_name}"]
    }
  }
}