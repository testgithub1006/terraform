resource "aws_instance" "ec2-instance" {
  ami            = var.ami_id
  instance_type  = "t2.micro"
  subnet_id      = aws_subnet.main-public-1.id
  
  security_groups = ["${aws_security_group.ec2-sg.id}"]
 
  
 
#vpc_security_group_ids = ["${aws_security_group.ec2-sg.id}"]
  

 
  user_data     = <<-EOF
                  #!/bin/bash
                  sudo su
                  yum -y install httpd

                # echo Hello from "$(hostname -i)" >> /var/www/html/index.html   # for accessing the private ip 
                  
                # echo Hello from "$(curl ifconfig.co)" >> /var/www/html/index.html  # for the public ip
                  
                 
                  echo Hello from "$(curl http://169.254.169.254/latest/meta-data/public-ipv4)" >> /var/www/html/index.html  # for the public ip
                  
                  sudo service httpd status
                  sudo service  httpd enable
                  sudo service httpd restart
                  EOF

tags = {
    Name = "tf-apache-server"
  }

# the public SSH key
  
#key_name = aws_key_pair.mykeypair.key_name


key_name = var.ami_key_pair_name



connection {
   user        = "ec2-user"
   host        = self.public_ip
   private_key = file("~/.ssh/id_rsa")
 }



}

output "public_ip" {

value="${aws_instance.ec2-instance.public_ip}"
       
}
