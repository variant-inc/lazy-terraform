variable "profile" {
  description = "AWS Account Number"
  default     = "default"
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  default     = "100"
}

variable "family" {
  description = "The family of the DB parameter group"
  default     = "postgres13"
}

variable "inbound_cidrs" {
  description = "CIDR block to expect requests to originate from ie the source/destination in es' security group"
  default     = ["0.0.0.0/0"]
}

variable "allow_major_version_upgrade" {
  description = <<EOT
  "Indicates that major version upgrades are allowed.
  Changing this parameter does not result in an outage and
  the change is asynchronously applied as soon as possible"
EOT
  default     = false
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  default     = false
}

variable "backup_window" {
  description = <<EOT
  "The daily time range (in UTC) during which automated backups are created if they are enabled.
  Example: '09:46-10:16'. Must not overlap with maintenance_window"
EOT
  default     = "16:00-17:00"
}

variable "maintenance_window" {
  description = <<EOT
  "Specifies the weekly time range for when maintenance on the cache cluster is performed.
  The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period.
  Example: sun:05:00-sun:09:00"
EOT
  default     = "sun:05:00-sun:09:00"
}

variable "engine" {
  description = "The database engine to use https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html"
  default     = "postgres"

  validation {
    condition     = contains(["postgres"], var.engine)
    error_message = "Supported values are [\"postgres\"]."
  }
}

variable "engine_version" {
  description = "The engine version to use"
  default     = "13"
}

variable "identifier" {
  description = "The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier"
  type        = string
}

variable "name" {
  description = "The name of the RDS database that has to be created"
  type        = string
  default     = null
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  default     = "db.r6g.large"
}

variable "iops" {
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'"
  default     = 1000
}

variable "max_allocated_storage" {
  description = "Specifies the value for Storage Autoscaling"
  default     = "1000"
}

variable "storage_type" {
  description = <<EOT
  "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD).
  The default is 'io1' if iops is specified, 'gp2' if not."
EOT
  default     = "gp2"
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  default     = false
}

variable "username" {
  description = "Username for the master DB user"
  default     = "variant"
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled"
  default     = false
}

variable "env" {
  description = "Type of RDS instance. Prod will have monitoring enabled always"
  default     = "dev"

  validation {
    condition     = contains(["prod", "dev"], var.env)
    error_message = "Supported values are [\"prod\", \"dev\"]."
  }
}

variable "user_tags" {
  description = "Mandatory tags fot the elk resources"
  type        = map(string)
}

variable "octopus_tags" {
  description = "Octopus Tags"
  type        = map(string)
}

variable "vpc_id" {
  description = "VPC to create the cluster in. If it is empty, then cluster will be created in `default-vpc`"
  default     = ""
}
