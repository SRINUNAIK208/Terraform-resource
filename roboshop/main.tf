module "catalogue" {
    source = "../Aws-roboshop"
    component = "catalogue"
    rule_priority = 20
}
module "user" {
    source = "../Aws-roboshop"
    component = "user"
    rule_priority = 30
}
module "cart" {
    source = "../Aws-roboshop"
    component = "cart"
    rule_priority = 40
}
module "shipping" {
    source = "../Aws-roboshop"
    component = "shipping"
    rule_priority = 50
}
module "payment" {
    source = "../Aws-roboshop"
    component = "payment"
    rule_priority = 60
}
module "frontend" {
    source = "../Aws-roboshop"
    component = "frontend"
    rule_priority = 70
}
