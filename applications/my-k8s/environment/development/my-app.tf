module "my-app" {
  source = "../../../../terraform_modules/my-k8s"
  eks_version = 1.33
  eks_name = "my-k8s-deployment"
  kms_key_arn = "arn:aws:kms:eu-west-1:091590067827:key/bfba2fa4-7cd0-45db-a413-6dcedcec673b"
  subnet_ids = ["subnet-0914dadca1d24ea8b", "subnet-0fe1fa0fbafe52313"]
  enable_endpoint_public_access = true
  node_groups = {
    webservice_workload = {
      capacity_type  = "ON_DEMAND"
      instance_types = ["t3.small"]

      scaling_config = {
        desired_size = 1
        max_size     = 2
        min_size     = 1
      }

      node_labels = {
        Environment = "Development"
        Application = "my-app"
      }
    }
  }
}
