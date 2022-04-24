variable "my_subnets" {
 type = map(object({
   cidr = string
   az   = string
   map_public_ip_on_launch = bool
   msg = string
 }))
 description = "Subnets for My VPC"
}