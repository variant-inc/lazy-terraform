variable "zone" {
  type = string
}

variable "profile" {
  type = string
}

variable "ec2_instance_name" {
  type    = string
  default = "name-not-provided"
}

variable "instance_purpose" {
  type = string
}

variable "instance_owner" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "associate_public_ip_address" { 
  type = bool
  default = false
}

variable "ec2_instance_type" {
  type    = string
  default = "t2.small"
}

variable "ebs_optimized" {
  type = bool
  default = true
}

variable "vpc_id" {
  type = string
}

variable "subnet_type" {
  type = string
}

variable "security_group_rules_data" {
  type = map(object({
      type = string
      from_port = number
      to_port = number
      protocol = string
      description = string
      cidr_blocks = list(string)
    })
  )
}

variable "ebs_volume_size" {
  type = number
}

variable "kms_key_id" {
  type = string
}

variable "ebs_vol_type" {
  type = string
}

variable "ebs_device_name" {
  type = string
  default = "/dev/sdh"
}

