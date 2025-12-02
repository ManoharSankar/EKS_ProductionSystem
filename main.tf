# Root module aggregator (optional but clean)
module "vpc" {
  source = "./vpc.tf"
}

module "eks" {
  source = "./eks.tf"
}
