#EC2 security group 

resource "aws_security_group" "website-SG" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.website.id

  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    iterator = port
    for_each = var.egressrules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = {
    Name = "website-SG"
  }
}

#RDS security group

resource "aws_security_group" "website_DB_security_group" {
  name        = "website_DB_security_group"
  description = "Enable MYSQL access on port 3306,80 and 22"
  vpc_id      = aws_vpc.website.id

  dynamic "ingress" {
    iterator = port
    for_each = var.DBingressrules
    content {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }


  dynamic "egress" {
    iterator = port
    for_each = var.DBegress
    content {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  tags = {
    Name = "website_DB_security_group"
  }
}