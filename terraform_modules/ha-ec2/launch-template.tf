resource "aws_launch_template" "this" {
  name          = var.ec2_launch_template_name
  image_id      = var.ec2_ami
  instance_type = var.ec2_instance_type
  key_name = var.ec2_key_pair_name

  dynamic "block_device_mappings" {
    for_each = var.ec2_block_device_mappings != null ? var.ec2_block_device_mappings : []
    content {
      device_name = block_device_mappings.value.device_name
      ebs {
        volume_size = block_device_mappings.value.volume_size
        # support optional fields if provided in mapping
        kms_key_id  = lookup(block_device_mappings.value, "kms_key_arn", null)
        encrypted   = lookup(block_device_mappings.value, "encrypted", true)
      }
    }
  }

  iam_instance_profile {
    arn = var.ec2_iam_role != null ? aws_iam_instance_profile.this[0].arn : null
  }

  metadata_options {
    http_endpoint               = var.http_endpoint
    http_tokens                 = var.http_tokens
    http_put_response_hop_limit = var.http_hop_limit
  }

  user_data              = var.user_data != null ? base64gzip(templatefile(var.user_data.template_name, var.user_data.variables)) : null
  vpc_security_group_ids = length(var.ec2_security_group_ids) > 0 ? var.ec2_security_group_ids : [aws_security_group.this.id]

  tags = var.tags
}
