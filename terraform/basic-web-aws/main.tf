resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
  
resource "aws_subnet" "publica" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "web" {
    vpc_id = aws_vpc.main.id
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "web" {
    ami = "ami-0c55b159cbfafe1f0"
    instance_type = var.instance_type
    subnet_id = aws_subnet.publica.id
    vpc_security_group_ids = [aws_security_group.web.id]
    user_data = <<-EOF
            #!/bin/bash
            apt-get update -y
            apt-get install -y nginx
            systemctl start nginx
    EOF
    tags = {
        Name = "servidor-web"
    }
}