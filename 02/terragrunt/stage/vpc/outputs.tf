output "vpc" {
  value = {
    "vpc_id" : module.vpc_example_simple-vpc.vpc_id
    "public_subnets" : module.vpc_example_simple-vpc.public_subnets
    "private_subnets" : module.vpc_example_simple-vpc.private_subnets
  }
}
