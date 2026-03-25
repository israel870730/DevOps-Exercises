locals {
  tags = {
    Environment         = "POC"
    Region              = "Americas"
  }

  vpc_id     = "vpc-0535f18c036735d00"
  subnet_ids = [
    "subnet-05cf66aa14f46359d",
    "subnet-05cf66aa14f46359d"
  ]
}