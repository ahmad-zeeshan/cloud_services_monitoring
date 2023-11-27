provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "prometheus_sg" {
  name        = "prometheus_sg"
  description = "Security group for Prometheus server and Grafana"

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "prometheus_server" {
  ami           = "ami-05a5f6298acdb05b6"
  instance_type = "t2.micro"
  key_name      = "my_terraform_key"
  security_groups = [aws_security_group.prometheus_sg.name]

  tags = {
    Name = "PrometheusServer"
  }
}

resource "aws_security_group" "node_exporter_sg" {
  name        = "node_exporter_sg"
  description = "Security group for Node Exporter instances"

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.prometheus_server.public_ip}/32"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust this to your IP for SSH access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "node_exporter" {
  count         = 2
  ami           = "ami-05a5f6298acdb05b6"
  instance_type = "t2.micro"
  key_name      = "my_terraform_key"
  security_groups = [aws_security_group.node_exporter_sg.name]

  tags = {
    Name = "NodeExporter-${count.index}"
  }
}
