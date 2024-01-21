provider "aws" {
    region = "ap-southeast-1"
}

resource "aws_instance" "tfec2" {
    ami = "ami-0fa377108253bf620"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.tfsg.name]
    key_name = "for-terraform"
    user_data = file("setup.sh")
}

resource "aws_eip" "tfeip" {
    instance = aws_instance.tfec2.id
}

output "E-IP" {
    value = aws_eip.tfeip.public_ip
}

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
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
