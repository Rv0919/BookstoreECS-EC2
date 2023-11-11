#Db-Subnet_Grp

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.main_subnet_private.id,aws_subnet.main_subnet_public1.id]
  
}

# Adding Resource RDS:

resource "aws_db_instance" "myrds" {
  allocated_storage   = var.allocated_storage
  storage_type        = var.storage_type
  identifier          = "rdstf"
  engine              = var.rds_engine
  engine_version      = "15.3"  # Use a valid  8.0 version available in your region
  instance_class      = var.db_instanceclass_type
  username            = "admin"
  password            = "Passw0rd!123"
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.name
  skip_final_snapshot = true

  tags = {
    Name = "MyRDS"
  }
}
