# A random suffix for resource names
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
  numeric = true
}

# Get 3 Availability Zones for the specified region
data "aws_availability_zones" "available" {
  state    = "available"
  filter {
    name   = "region-name"
    values = [var.region]
  }
}

# Local variables for centralized name and AZ management
locals {
  cluster_name = "${var.cluster_name_prefix}-${random_string.suffix.result}"
  # Ensure we only use the first 3 AZs for ap-south-1
  azs          = slice(data.aws_availability_zones.available.names, 0, 3)
}