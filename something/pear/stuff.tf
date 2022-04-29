resource "aws_instance" "web" {
  ami           = "ami-0dcc0ebde7b2e00db"
  instance_type = "t3.micro"

  tags = {
    project = "pear"
    fruit = "maybe"
  }
}
