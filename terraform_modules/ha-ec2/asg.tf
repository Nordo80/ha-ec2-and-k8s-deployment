resource "aws_autoscaling_group" "this" {
  name                = var.asg_name
  vpc_zone_identifier = var.ec2_subnet_ids

  desired_capacity = var.asg_desired_capacity
  max_size         = var.asg_max_size
  min_size         = var.asg_min_size

  health_check_type = "EC2"

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.asg_name
    propagate_at_launch = true
  }
}
