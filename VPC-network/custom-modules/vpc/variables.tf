## You should declare every variable you've used in this module

variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "app-public-subnet1-cidr" {
  type = string
}

variable "app-public-subnet2-cidr" {
  type = string
}

variable "app-private-subnet1-cidr" {
  type = string
}

variable "app-private-subnet2-cidr" {
  type = string
}

variable "db-private-subnet1-cidr" {
  type = string
}

variable "db-private-subnet2-cidr" {
  type = string
}

variable "public-firewall-ports" {
  type = list
}

variable "private-firewall-ports" {
  type = list
}

variable "db-firewall-ports" {
  type = list
}
