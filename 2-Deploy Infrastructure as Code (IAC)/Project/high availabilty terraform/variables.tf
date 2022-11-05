variable "MayVpcCider" {
  description = "VPC Range"
  type        = string
  default     = "10.0.0.0/16"

}

variable "EnvName" {
  description = "Environment Name"
  type        = string
  default     = "Project2Terraform"

}
variable "PublicSubnet1" {
  description = "VPC Range"
  type        = string
  default     = "10.0.1.0/24"

}

variable "PublicSubnet2" {
  description = "Environment Name"
  type        = string
  default     = "10.0.2.0/24"

}
variable "PrivateSubnet1" {
  description = "Environment Name"
  type        = string
  default     = "10.0.3.0/24"

}
variable "PrivateSubnet2" {
  description = "Environment Name"
  type        = string
  default     = "10.0.4.0/24"

}