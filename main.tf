terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region     = var.aws_config.aws_region
  profile    = "code-academy-sandbox"
  access_key = var.aws_config.aws_access_key
  secret_key = var.aws_config.aws_secret_key
  token      = var.aws_config.aws_session_token
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "final_evaluation" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = "Final Evaluation"
  }
}

resource "aws_internet_gateway" "final_evaluation" {
  vpc_id = aws_vpc.final_evaluation.id

  tags = {
    Name = "Final Evaluation"
  }
}

resource "aws_subnet" "final_evaluation_public" {
  count             = var.subnet_count.public
  vpc_id            = aws_vpc.final_evaluation.id
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "Final Evaluation Public Subnet ${count.index}"
  }
}

resource "aws_route_table" "final_evaluation_public" {
  vpc_id = aws_vpc.final_evaluation.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.final_evaluation.id
  }

  tags = {
    Name = "Final Evaluation"
  }
}

resource "aws_route_table_association" "final_evaluation_public" {
  count          = var.subnet_count.public
  route_table_id = aws_route_table.final_evaluation_public.id
  subnet_id      = aws_subnet.final_evaluation_public[count.index].id
}

resource "aws_security_group" "final_evaluation_ec2" {
  name   = "final_evaluation_ec2"
  vpc_id = aws_vpc.final_evaluation.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = false
  }

  ingress {
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = false
  }


  ingress {
    from_port   = 80
    to_port     = 80
    description = "Allow http"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = false
  }

  ingress {
    from_port   = 443
    to_port     = 443
    description = "Allow http with ssl"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = false
  }

  ingress {
    from_port   = 22
    to_port     = 22
    description = "Allow traffic from ssh client"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = false
  }

  egress {
    description = "Any outbound allowed"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Final Evaluation"
  }
}

resource "aws_key_pair" "final_evaluation" {
  key_name   = "final_evaluation"
  public_key = file("public_key.pem")
  tags = {
    Name = "Final Evaluation"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "final_evaluation_web" {
  count         = 1
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.settings.web_app.instance_type
  subnet_id     = aws_subnet.final_evaluation_public[count.index].id
  # user_data                   = file("./scripts/setup.sh")
  associate_public_ip_address = true
  key_name                    = aws_key_pair.final_evaluation.key_name
  vpc_security_group_ids      = [aws_security_group.final_evaluation_ec2.id]

  tags = {
    Name = "Final Evaluation"
  }
}
