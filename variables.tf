variable "tfe_org" {
  description = "Name of TFE organization which has workspace containing vpc to use."
}

# Assumes that each workspace tracking resource groups has a unique region
variable "vpc_workspace" {
  description = "Name of TFE workspace managing deployment of vpc to use."
}

# Assumes that each workspace tracking resource groups has a unique region
variable "sg_workspace" {
  description = "Name of TFE workspace managing deployment of vpc to use."
}
variable "os" {
  description = "Specify OS to use (linux/windows)"
  default = "linux"
}
variable "instance_type" {
  description = "Specify instance type to use"
  default = "t2.micro"
}
variable "instance_count" {
  description = "Specify how many instance to deploy"
  default = "1"
}
variable "tags" {
  type = "map"

  default = {
    Name = "Stenio Test"
    Owner = "Stenio Ferreira"
    TTL = "48"
    Environment = "dev"
  }
}