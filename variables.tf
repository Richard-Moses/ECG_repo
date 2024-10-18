variable "environment" {
  description = "The environment for the resources"
  type        = string
  default     = "development"  # Change to "staging" or "production" as needed
}

variable "region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = "eu-west-2"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "instance_ami" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {
    Name = "ECG-Ghana"
  }
}
