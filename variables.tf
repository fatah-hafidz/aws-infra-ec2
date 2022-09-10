variable "CREATE_EIP" {
  description = "If set to true, create an EIP for the service"
}
variable "PROJECT_NAME" {
  description = "Project Name"
}
variable "EC2_INSTANCE_TYPE" {
  description = "EC2 instance type. e.g. t3a.micro"
}
variable "AMI_WEB_SG" {
  description = "AMI for EC2 Web in particular region -- make sure your region is correct"
}

variable "ENV" {
  description = "Env for the project e.g prod"
}
variable "ENV_TAG" {
  description = "Environment tag - useful for cost explorer"
}

variable "PUBA_ID" {
  description = "public subnet a id"
}

variable "PUBB_ID" {
  description = "public subnet b id"
}

variable "PUBC_ID" {
  description = "public subnet c id"
}
variable "SGWEB_ID" {
  description = "security group web instance id"
}

variable "SGCF_ID" {
  description = "security group range of CF ip's"
}

variable "VOL_TYPE" {
  description = "volume type. I suggest to use gp3 for better price (a bit pricey compared to gp2)"
}

variable "VOL_SIZE" {
  description = "volume size. Start small! we can always attach new EBS volume if the need arise"
}

variable "EC2_COUNT" {
  description = "defines how many instance you want to create."
}

variable "MORE_VOL" {
  description = "Should this instance have additional volume"
  default= false
}
