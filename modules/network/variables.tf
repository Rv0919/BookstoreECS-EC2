variable "cidr_block" {
    description = "VPC CIDR Block"
    # default = "10.0.0.0/16"
  
}

variable "public_subnet_cidr" {
    description = "Public Subnet CIDR"
    # default = "10.0.1.0/24"
  
}

variable "private_subnet_cidr" {
    description = "Private Subnet CIDR"
    # default = "10.0.2.0/24"
  
}

variable "public_subnet_cidr1" {
    description = "Public Subnet CIDR1"
    # default = "10.0.3.0/24"
  
}

variable "region_location" {
    description = "Region_Selected"
  
}

variable "ami" {
    description = "Image Id for Ec2"
  
}

variable "instance_type" {
    description = "Type of Instance"
  
}
variable "protocol" {
  description = "Type of  Protocol"
}