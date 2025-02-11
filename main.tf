# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"  # Set AWS region to US East 1 (N. Virginia)
}


# Make a security group, or a firewall so as to allow the SSH and HTTP traffic.
resource "aws_security_group" "allow_http_ssh_traffic"{
  name = "allow_http"
  description = "Allow http inbound and outbound traffic"
  
  ingress{
    description = "http"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
  }

  ingress{
    description = "ssh"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"  # It stands that any protocol will be fine, packet following any protocol will be allowed to leave.
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_ssh"
  }
}


# Local variables block for configuration values
locals {
    aws_key = "RM_AWS_KEY"   # SSH key pair name for EC2 instance access
}

# EC2 instance resource definition
resource "aws_instance" "my_server" {
  ami = data.aws_ami.amazonlinux.id  # Get the Amazon Linux ami
  instance_type = var.instance_type  # In this case we are using t2.micro.
  key_name = local.aws_key  # Uses the local value, so that we don't have to keep redefining the key.

  user_data = filebase64("wp_install.sh")  # Executes the install script.
  vpc_security_group_ids = [aws_security_group.allow_http_ssh_traffic.id]  # Specify the security group for HTTP access, it requires id and not name hence .id

  tags = {
  Name = "my_ec2"
}

}
