variable "public_key" {
  type = string
  description="\Docker\final\Keys\key.pub"
  default = "~/.ssh/id_rsa.pub"

}

variable "privater_key" {
  type = string
  description="\Docker\final\Keys\key"
  default = "~/.ssh/id_rsa"

}