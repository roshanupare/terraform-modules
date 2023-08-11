resource "aws_iam_user" "demo-user" {
  count = length(var.users_name)
  name = "${var.users_name[count.index]}-${var.env}"
  tags = {
    Environment = var.env
  }
}

# resource "aws_iam_user" "users" {
#   count = 10
#   name  = "user${count.index}-${var.env}"
# }
