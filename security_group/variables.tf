variable "project" {
    default = "roboshop"
}
variable "environment" {
    default = "dev"
}
variable "vpn_ports"{
    default = ["22","1194","443","943"]
}
variable "mongodb_ports" {
    default = ["22","27017"]
}

variable "redis_ports" {
    default = [22, 6379]
}

variable "mysql_ports" {
    default = [22, 3306]
}

variable "rabbitmq_ports" {
    default = [22, 5672]
}