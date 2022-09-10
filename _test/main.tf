provider "aws" {
  region = "ap-southeast-1"
}

module "ec2" {
  source = "../"

  PROJECT_NAME      = "test"
  EC2_INSTANCE_TYPE = "t2.nano"
  AMI_WEB_SG        = "ami-test"
  ENV_TAG           = "Production"
  ENV               = "prod"
  SGWEB_ID          = "web-sg"
  SGCF_ID           = "cf-sg"
  VOL_TYPE          = "gp3"
  VOL_SIZE          = "20"
  MORE_VOL          = true
  CREATE_EIP        = false
  EC2_COUNT         = "1"
  PUBA_ID           = "pub-1a"
  PUBB_ID           = "pub-1b"
  PUBC_ID           = "pub-1c"

}

