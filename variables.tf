variable "project_name" {
  default = "m1"
}

variable "memory_cluster" {
  default = 2048
  type = number
}

variable "cpu_cluster" {
  default = 1024
  type = number
}

variable "launch_type" {
  default = "FARGATE"
}

variable "desired_count" {
  default = 2
  type = number
}

variable "aws_region" {
  default = "ap-southeast-1"
}

variable "autoscaling_policy_type" { 
  default = "TargetTrackingScaling"
}

variable max_capacity_usage {
  default = 80
  type = number
}

variable image_tag { 
  default = "0.0.1-rc"
}

variable "http_host" {
  default = "localhost"
}

variable "http_port" {
  default = "3000"
}

variable "http_timeout" {
  default = "30000"
}

variable "timezone" {
  default = "Asia/Bangkok"
}
