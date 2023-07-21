#creating RDS 


#database subnet group
resource "aws_db_subnet_group" "website_db_sub_group" {
  name        = "website_database_subnets"
  subnet_ids  = [aws_subnet.web-public-subnet1.id, aws_subnet.web-public-subnet2.id]
  description = "subnet for database instance"


  tags = {
    Name = "website_db_sub_group"
  }
}

#Terraform aws db instance
resource "aws_db_instance" "website_db_database" {
  allocated_storage      = var.allocated_storage
  engine                 = var.Engine_type
  engine_version         = var.Engine_version
  instance_class         = var.instance_class
  skip_final_snapshot    = true
  availability_zone      = var.db_instance_az
  identifier             = "website-database"
  username               = "admin"
  password               = "agyekum97"
  db_subnet_group_name   = aws_db_subnet_group.website_db_sub_group.id
  multi_az               = false
  vpc_security_group_ids = [aws_security_group.website_DB_security_group.id]
}