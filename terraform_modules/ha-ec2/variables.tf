variable "ec2_ami" {
  description = "The ID of the AMI to use for the EC2 instances."
  type        = string
}

variable "ec2_instance_type" {
  description = "The type of EC2 instance to launch."
  type        = string
  default     = "t3.micro"
}

variable "ec2_block_device_mappings" {
  description = "List of extra block device mappings (device_name, volume_size, optional kms_key_arn, optional encrypted)."
  type = list(object({
    device_name  = string
    volume_size  = number
    kms_key_arn  = optional(string)
    encrypted    = optional(bool, true)
  }))
  default = []
}

variable "ec2_root_block_device" {
  description = "Root block device configuration."
  type = object({
    encrypted   = optional(bool, true)
    volume_size = number
    kms_key_arn = optional(string)
  })
  default = null
}

variable "ec2_key_pair_name" {
  description = "Key pair name"
  type        = string
  default     = "my-app-kms-key"
}

variable "ec2_launch_template_name" {
  description = "Name of the launch template to be created"
  type        = string
}

variable "ec2_security_group_ids" {
  description = "A list of security group IDs to associate with the EC2 instances (can be empty; module creates SG.this)."
  type        = list(string)
  default     = []
}

variable "ec2_iam_role" {
  description = "The IAM instance profile name (if you prefer to pass existing profile name)."
  type        = string
  default     = null
}

variable "user_data" {
  description = "User data for configuring instances, including a template name and variables."
  type = object({
    template_name = string
    variables     = any
  })
  default = null
}

variable "asg_name" {
  description = "Name of the Auto Scaling Group."
  type        = string
  default     = "my-ha-ec2"
}

variable "asg_desired_capacity" {
  description = "The number of EC2 instances you want running at any given time."
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum number of EC2 instances that Auto Scaling is allowed to scale up to."
  type        = number
  default     = 1
}

variable "asg_min_size" {
  description = "Minimum number of EC2 instances that Auto Scaling must always keep running."
  type        = number
  default     = 1
}

variable "ec2_subnet_ids" {
  description = "List of subnet ids where ASG will launch instances (must be at least 2 for HA)."
  type        = list(string)
  default     = []
}

variable "iam_policy" {
  description = "IAM policy configuration specifying the effect, actions, and resources."
  type = map(object({
    effect    = string
    actions   = list(string)
    resources = list(string)
  }))
  default = {}
}

variable "iam_assume_role_policy" {
  description = "The policy for assuming the role."
  type = object({
    effect  = optional(string, "Allow")
    actions = optional(list(string), ["sts:AssumeRole"])
    principals = optional(list(object({
      type        = string
      identifiers = list(string)
    })), [{ type = "Service", identifiers = ["ec2.amazonaws.com"] }])
  })
  default = { actions = ["sts:AssumeRole"], principals = [{ type = "Service", identifiers = ["ec2.amazonaws.com"] }] }
}

variable "iam_role_name" {
  description = "The name of the IAM role."
  type        = string
  default     = "ha-ec2-role"
}

variable "iam_additional_policies" {
  description = "Additional IAM policies to attach to the IAM role."
  type        = list(string)
  default     = []
}

variable "sg_name" {
  description = "The name of the security group for EC2."
  type        = string
  default     = "ha-ec2-sg"
}

variable "sg_vpc_id" {
  description = "The ID of the VPC associated with the security groups."
  type        = string
}

variable "sg_description" {
  description = "The description of the security group."
  type        = string
  default     = "EC2 SG"
}

variable "sg_ingress_rules" {
  description = "Ingress rules for the EC2 security group."
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = list(string)
    description     = string
    security_groups = optional(list(string))
  }))
  default = [
    {
      from_port       = 22
      to_port         = 22
      protocol        = "TCP"
      cidr_blocks     = ["0.0.0.0/0"]
      description     = "Allow ssh"
    }
  ]
}

variable "sg_egress_rules" {
  description = "Egress rules for the security group."
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = list(string)
    description     = string
    security_groups = optional(list(string))
  }))
  default = [
    {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      cidr_blocks     = ["0.0.0.0/0"]
      description     = "Allow all"
    }
  ]
}


variable "http_endpoint" {
  description = "Whether the metadata service has an HTTP endpoint."
  type        = string
  default     = "enabled"
}

variable "http_tokens" {
  description = "Whether the metadata service requires session tokens."
  type        = string
  default     = "required"
}

variable "http_hop_limit" {
  description = "Desired HTTP PUT response hop limit for instance metadata requests."
  type        = number
  default     = 1
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
