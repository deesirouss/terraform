variable "myvar" {
  type    = string
  default = "hello terraform"
}
variable "mymap" {
  type = map(string)
  default = {
    mykey = "my value"
  }
}
variable "list" {
  type    = list(any)
  default = [1, 2, 3]
}
variable "iam_users" {
  description = "map"
  type        = map(string)
  default     = {
    user1      = "normal user"
    user2  = "admin user"
    user3 = "root user"
  }
}
variable "user_names" {
  description = "IAM usernames"
  type        = list(string)
  default     = ["user1", "user2", "user3"]
} 
