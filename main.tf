resource "aws_launch_template" "web_server_as" {
    name = "myproject"
    image_id           = "ami-0b0b78dcacbab728f"
    vpc_security_group_ids = [aws_security_group.web_server.id]
    instance_type = "t3.micro"
    key_name = "one"
    tags = {
        Name = "DevOps"
    }
    
}
   


  resource "aws_elb" "web_server_2b"{
     name = "web-server-2b"
     security_groups = [aws_security_group.web_server.id]
     subnets = ["subnet-0d18ad490c15f35e5", "subnet-00a7d29eb203c35d0"]
     listener {
      instance_port     = 8000
      instance_protocol = "http"
      lb_port           = 80
      lb_protocol       = "http"
    }
    tags = {
      Name = "terraform-elb"
    }
  }
resource "aws_autoscaling_group" "web_server_asg" {
    name                 = "web-server-asg"
    min_size             = 1
    max_size             = 3
    desired_capacity     = 2
    health_check_type    = "EC2"
    load_balancers       = [aws_elb.web_server_2b.name]
    availability_zones    = ["us-east-2a", "us-east-2b"] 
    launch_template {
        id      = aws_launch_template.web_server_as.id
        version = "$Latest"
      }
    
    
  }

