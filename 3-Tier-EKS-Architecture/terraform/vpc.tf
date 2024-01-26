module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  name = "main"
  cidr = "10.0.0.0/16"

  azs = var.availability_zones
  private_subnets = ["10.0.0.0/19", "10.0.32.0/19"]
  public_subnets = ["10.0.64.0/19", "10.0.96.0/19"]

  // This tag applied to subnets is for internal and external-facing load balancers when they are deployed.
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }


   enable_dns_hostnames = true
   enable_dns_support = true

   enable_nat_gateway = true
   single_nat_gateway = true
   one_nat_gateway_per_az = true

   tags = {
    Environment = "dev"
   }

}