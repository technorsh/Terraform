my_subnets = {
 "my_subnet1" = {
   cidr = "10.0.1.0/24"
   az   = "us-east-1a"
   map_public_ip_on_launch = true
   msg = "Public"
 },
 "my_subnet2" = {
   cidr = "10.0.2.0/24"
   az   = "us-east-1b"
   map_public_ip_on_launch = true
   msg = "Public"
 },
 "my_subnet3" = {
   cidr = "10.0.3.0/24"
   az   = "us-east-1c"
   map_public_ip_on_launch = true
   msg = "Public"
 },
 "my_subnet4" = {
   cidr = "10.0.4.0/24"
   az   = "us-east-1d"
   map_public_ip_on_launch = false
   msg = "Private"
 },
 "my_subnet5" = {
   cidr = "10.0.5.0/24"
   az   = "us-east-1e"
   map_public_ip_on_launch = false
   msg = "Private"
 }
}