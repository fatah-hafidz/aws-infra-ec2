## This line for workflow testing - 1
#### EC2 instances ####

#data "template_file" "server_userdata" {
#  template = file("${path.module}/web.sh")
#}

resource "aws_instance" "ec2_web" {
  count                  = var.EC2_COUNT
  ami                    = var.AMI_WEB_SG
  instance_type          = var.EC2_INSTANCE_TYPE
  key_name               = format("%s-%s", var.PROJECT_NAME, var.ENV)
  subnet_id              = random_shuffle.subnets.result[0]
  vpc_security_group_ids = [var.SGWEB_ID, var.SGCF_ID]
  root_block_device {
    delete_on_termination = true
    volume_size           = 15
    volume_type           = "gp3"
    tags = {
      Project = var.PROJECT_NAME
    }
  }

  #user_data  = data.template_file.server_userdata.rendered
  monitoring = true
  tags = {
    Name    = format("%s-%s", var.PROJECT_NAME, var.ENV)
    Project = var.PROJECT_NAME
  }

}

resource "random_shuffle" "subnets" {
  input        = [var.PUBA_ID, var.PUBB_ID, var.PUBC_ID]
  result_count = 1
}

resource "aws_eip" "eip" {
  count    = var.CREATE_EIP ? 1 : 0
  instance = aws_instance.ec2_web.*.id[count.index]
  tags = {
    Project = var.PROJECT_NAME
  }

}

resource "aws_ebs_volume" "app_vol" {
  count             = var.MORE_VOL ? 1 : 0 
  availability_zone = aws_instance.ec2_web.*.availability_zone[count.index]
  size              = var.VOL_SIZE
  type              = var.VOL_TYPE
  tags = {
    Project = var.PROJECT_NAME
  }
}

resource "aws_volume_attachment" "app_vol" {
  count       = var.MORE_VOL ? 1 : 0
  device_name = "/dev/xvdb"
  instance_id = aws_instance.ec2_web.*.id[count.index]
  volume_id   = aws_ebs_volume.app_vol.*.id[count.index]
}


resource "tls_private_key" "priv_key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "ssh" {

  key_name   = format("%s-%s", var.PROJECT_NAME, var.ENV)
  public_key = tls_private_key.priv_key.public_key_openssh
}


output "ec2_web_pub_ip" {
  value = aws_instance.ec2_web.*.public_ip
}
output "ssh_key_name" {
  description = "The key pair name."
  value       = aws_key_pair.ssh.key_name
}

output "ssh_key_pair_id" {
  description = "The key pair ID."
  value       = aws_key_pair.ssh.key_pair_id
}

output "ssh_key_fingerprint" {
  description = "The MD5 public key fingerprint as specified in section 4 of RFC 4716."
  value       = aws_key_pair.ssh.fingerprint
}

output "ec2_web_az" {
  value = aws_instance.ec2_web.*.availability_zone
}

output "ec2_web_instance_id" {
  value = aws_instance.ec2_web.*.id
}


