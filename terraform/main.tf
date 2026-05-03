module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = "10.0.0.0/16"
  project  = "3tier"
  env      = "dev"

  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  azs = ["us-east-2a", "us-east-2b"]
}

module "security" {
  source  = "./modules/security"

  vpc_id  = module.vpc.vpc_id
  project = "3tier"
  env     = "dev"
}


module "alb" {
  source = "./modules/alb"

  project = "3tier"
  env     = "dev"

  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets

  alb_sg_id          = module.security.alb_sg_id
  internal_alb_sg_id = module.security.internal_alb_sg_id
}


module "compute" {
 source = "./modules/compute"

  project = "3tier"
  env = "dev"

  ami_id = "ami-018d49b53eee64386"
  instance_type = "t3.medium"

  web_sg_id = module.security.web_sg_id
  app_sg_id = module.security.app_sg_id

  public_subnets  = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets

  web_tg_arn = module.alb.web_tg_arn
  app_tg_arn = module.alb.app_tg_arn

    

}

module "rds" {
  source = "./modules/rds"

  project = "3tier"
  env     = "dev"

  instance_class = "db.t3.medium"

  db_name     = "mydb"
  db_username = var.db_username
  db_password = var.db_password

  private_subnets = module.vpc.private_subnets
  db_sg_id        = module.security.db_sg_id
}


