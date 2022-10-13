#---root/main.tf---

module "networking" {
  source        = "./networking"
  vpc_cidr      = local.vpc_cidr
  public_cidrs  = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidrs = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  access_ip     = var.access_ip
}

module "compute" {
  source                    = "./compute"
  public_sg                 = module.networking.public_sg
  public_subnet             = module.networking.public_subnet
  private_sg                = module.networking.private_sg
  private_subnet            = module.networking.private_subnet
  loadbalancer_target_group = module.loadbalancer.loadbalancer_target_group
  elb                       = module.loadbalancer.elb
  key_name                  = "krypt0_21_keypair"
}

module "loadbalancer" {
  source                  = "./loadbalancer"
  public_subnet           = module.networking.public_subnet
  vpc_id                  = module.networking.vpc_id
  web_server_sg           = module.networking.web_server_sg
  krypt0_21_webserver_asg = module.compute.krypt0_21_webserver_asg
}