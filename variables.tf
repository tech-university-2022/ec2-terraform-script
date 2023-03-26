variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_count" {
  description = "Number of subnets"
  type        = map(number)
  default = {
    public  = 1,
    private = 2
  }
}

variable "settings" {
  description = "Configuration settings"
  type        = map(any)
  default = {
    "web_app" = {
      count         = 1          // the number of EC2 instances
      instance_type = "t3.micro" // the EC2 instance
    }
  }
}

// This variable contains the CIDR blocks for
// the public subnet. I have only included 4
// for this tutorial, but if you need more you 
// would add them here
variable "public_subnet_cidr_blocks" {
  description = "Available CIDR blocks for public subnets"
  type        = list(string)
  default = [
    "10.0.5.0/24",
    "10.0.6.0/24",
    "10.0.7.0/24",
    "10.0.8.0/24"
  ]
}

variable "aws_config" {
  description = "AWS Configuration"
  type        = map(string)
  default = {
    "aws_region"        = "us-east-1",
    "aws_access_key"    = "ASIA5SXCFM27NUKFMMXL",
    "aws_secret_key"    = "qYtvfqDVMcUifnFkGYMRWwA/WylniEmBtBuo5D50",
    "aws_session_token" = "FwoGZXIvYXdzEEgaDHP+T9wvJLBcAqVptiKJA9KRxNY+488bTNEE3IrpT7o4tJz9HiCotnXc/JHEhaa7gVmVEVGSYn2auflpEU3BR5Gx5ULqUWtSaPbBLUz3DbZD8/grPOx1/npwcF9Ozjc1/hEaefw0cNGDXOPjrE+sgIg+SFUNipa4dQxuuPZDc4momN2pEHgrxmGBKdhRTZSi0XJvTkKkFB46dWEkq6dQZhz2UhUbw75WftXVR8Ou7/GvWt5y1mbY9/5hRgUDaUKj8qGvLQnNUEyCUSafJ56A3jWZ0l/Dv02IKBByHmi8UKRrEAO6xk5AsmrCauDTXSlm3wz5E8SQY3eVPRUF/QMmMCUZd2xqK89mEJn57bxC1Ngjw22/K7hcYpoG1Wuw1I0r+d5Z5+HboVdwAn5UU7XLifHTt3HXbMdLRUUFegJ3xKzMTDK9Ikq7t0T/Ib1/jHIuxX0TEdXIMb85uwrKmWWo806e7GqHo1MOYaMw9zAapnKmq8mF/L4Q/nOh0ECNHLXTKlyta+ZSg7mRikVlldT4QmcwO4X5EHguiyjc2/+gBjInCQQyQyUMSPlSo9R9ezmaGUpEkjknaKW9lvheVGl5rXXtJ7ViQiy3"
  }
}
