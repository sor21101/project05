variable "project_name" {
  description = "Project name"
  type        = string
  default     = "project05"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-northeast-2"
}

variable "avaliability_zone" {
  description = "Avaliability Zone"
  type        = string
  default     = "ap-northeast-2a"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR block"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "EC2 Key Pair Name"
  type        = string
}

variable "ssh_cidr" {
  description = "CIDR allowed to access SSH"
  type        = string
}

variable "aws_db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "db_name" {
  description = "Initial PostgreSQL database name"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "PostgreSQL master username"
  type        = string
  default     = "entks"
}

variable "db_password" {
  description = "PostgreSQL master password"
  type        = string
  sensitive   = true
}

variable "github_owner" {
  description = "Github repository owner"
  type        = string
}

variable "github_repo" {
  description = "Github repository name"
  type        = string
}

variable "github_branch" {
  description = "Github branch allowed to deploy"
  type        = string
  default     = "main"
}

variable "github_owner_id" {
  type = string
}

variable "github_repo_id" {
  type = string
}