variable "ec2_instance_type" {
    default = "t2.micro"
    type = string
  
}

variable "ec2_ami_id" {
    default = "ami-0f918f7e67a3323f0"
    type = string
  
}

variable "ec2_block_size" {
    default = 15   
    type = number
  
}

variable "vpc_cidr_block" {
    default = "10.0.0.0/16"
    type = string
  
}

variable "subnet_cidr_block" {
    default = "10.0.1.0/24"
   type = string
}

variable "azs" {
    default = ["ap-south-1a" , "ap-south-1b"]
    type = list(string) 
  
}


  

