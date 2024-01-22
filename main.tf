# tells terraform i am using AWS and set region as singapore
provider "aws" {
    region = "ap-southeast-1"
}

# this creates a new EC2 instance with the ubuntu server AMI
# this EC2 instance will use t2.micro as instance type
# the security group associated to this EC2 instance will be listed below
# associate a existing keypair "for-terraform" to this EC2 instance
# after this EC2 instance starts, the setup.sh will be run as user data
resource "aws_instance" "tfec2" {
    ami = "ami-0fa377108253bf620"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.tfsg.name]
    key_name = "for-terraform"
    user_data = file("setup.sh")
}

# this creates a elastic ip address and associate it with the newly created EC2 instance
resource "aws_eip" "tfeip" {
    instance = aws_instance.tfec2.id
}

# output elastic ip-address on terminal (for debugging purposes)
output "E-IP" {
    value = aws_eip.tfeip.public_ip
}

# new security group created (to be associated with newly created EC2) that allows ingress and egress ports 443 (HTTPS), 80 (HTTP), and 22 (SSH)
resource "aws_security_group" "tfsg" {
    name = "terraform-security-group"

    ingress {
        from_port = 443
        to_port = 443
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 443
        to_port = 443
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
