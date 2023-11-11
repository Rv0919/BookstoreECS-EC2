#Creating ECR:

resource "aws_ecr_repository" "my_ecr_repo" {
  name                 = "ecr"
  image_tag_mutability = "MUTABLE"
  

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name="Terraform_ECR"
  }

}
output "ecr_output" {
    value = aws_ecr_repository.my_ecr_repo.repository_url
  }