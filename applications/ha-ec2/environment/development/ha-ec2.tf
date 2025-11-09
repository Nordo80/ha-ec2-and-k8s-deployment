module "ha-ec2" {
  source = "../../../../terraform_modules/ha-ec2"

  ec2_launch_template_name  = "ha-ec2"
  ec2_ami                   = "ami-06297e16b71156b52"

  ec2_subnet_ids = [
    "subnet-0914dadca1d24ea8b",
    "subnet-0fe1fa0fbafe52313"
  ]

  ec2_iam_role = "ha-ec2-role"
  ec2_root_block_device = {
    volume_size = 40
    kms_key_arn = "arn:aws:kms:eu-west-1:091590067827:key/bfba2fa4-7cd0-45db-a413-6dcedcec673b"
  }
  iam_role_name           = "ha-ec2-role"

  sg_name        = "ha-ec2-sg"
  sg_vpc_id      = "vpc-0ca2a3578225fd271"
  sg_description = "HA EC2 security group"

  sg_ingress_rules = [
    {
      description     = "SSH allowed from your IP"
      from_port       = 22
      to_port         = 22
      protocol        = "tcp"
      cidr_blocks     = ["88.196.208.91/32"]
      security_groups = null
    }
  ]

  sg_egress_rules = [
    {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      cidr_blocks     = ["0.0.0.0/0"]
      description     = "all outbound"
      security_groups = null
    }
  ]


  asg_min_size          = 2
  asg_max_size          = 3
  asg_desired_capacity  = 2

  ec2_block_device_mappings = [
    {
      device_name = "/dev/sdh"
      volume_size = 10
      kms_key_arn = "arn:aws:kms:eu-west-1:091590067827:key/bfba2fa4-7cd0-45db-a413-6dcedcec673b"
    },
    {
      device_name = "/dev/sdi"
      volume_size = 10
      kms_key_arn = "arn:aws:kms:eu-west-1:091590067827:key/bfba2fa4-7cd0-45db-a413-6dcedcec673b"
    }
  ]
}
