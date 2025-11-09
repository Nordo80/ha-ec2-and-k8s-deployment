output "asg_name" {
  description = "Autoscaling group name"
  value       = aws_autoscaling_group.this.name
}

output "launch_template_id" {
  description = "Launch template id"
  value       = aws_launch_template.this.id
}

output "ec2_security_group_id" {
  description = "EC2 security group id created by module"
  value       = aws_security_group.this.id
}

output "iam_role_name" {
  description = "IAM role name"
  value       = aws_iam_role.this.name
}

output "iam_role_arn" {
  description = "IAM role ARN"
  value       = aws_iam_role.this.arn
}
