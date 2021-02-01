variable "region" {
  type = string
  default = "us-east-1"
  description = "Default region for AWS provider"
}

variable "profile" {
  type = string
  description = "Credentials profile for AWS provider"
}

variable "ec2_instance_name" {
  type    = string
  default = "name-not-provided"
  description = "Name given to ec2 instance. Used as prefix to other resources"
}

variable "instance_purpose" {
  type = string
  description = "Purpose of the instance; used for tags"
}

variable "instance_owner" {
  type = string
  description = "Owner of the instance; used for tags"
}

variable "ami_id" {
  type = string
  description = "ID of the AMI of the instance"
}

variable "associate_public_ip_address" { 
  type = bool
  default = false
  description = "Attach public IP to instance?"
}

variable "ec2_instance_type" {
  type    = string
  default = "t2.small"
  description = "Machine type of the instance"
}

variable "ec2_instance_role" {
  type    = string
  default = "awsssmdefault"
  description = "Role assigned to the instance"
}

variable "ebs_optimized" {
  type = bool
  default = true
  description = "Optomize instance for EBS?"
}

variable "vpc_id" {
  type = string
  description = "ID of VPC to attach security group to"
}

variable "subnet_type" {
  type = string
  description = "One of: public or private"
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
  description = "Ingress/Egress rules for the security group"
}

variable "ebs_volume_size" {
  type = number
  description = "Size of EBS volume in GB"
}

variable "kms_key_id" {
  type = string
  description = "KMS Key for disk encryption"
}

variable "ebs_vol_type" {
  type = string
  default = "gp2"
  description = "Volume type of EBS instance. One of: standard, gp2, gp3, io1, io2, sc1 or st1"
}

variable "ebs_device_name" {
  type = string
  default = "/dev/sdh"
  description = "Device name given to EBS volume of the instance"
}

variable "alarm_sns_arn" {
  type = string
  description = "ARN for the SNS topic accepting CloudWatch Alerts"
}
