environment    = "development"
region         = "eu-west-2"
vpc_cidr       = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
instance_ami   = "ami-0c55b159cbfafe1f0"
instance_type  = "t2.micro"
tags = {
  Name = "ECG-Ghana-Dev"
}
