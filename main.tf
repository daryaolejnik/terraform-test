provider "google" {
  region    = "us-central1"
  zone   = "us-central1-a"
  version   = "=3.0.0"
  project   = "balmy-tokenizer-321318"
  credentials = "E:\\balmy-tokenizer-321318-0c66f882cadf.json"
  }

provider "google-beta" {
  region = "us-central1"
  zone   = "us-central1-a"
  version = "=3.20"
  project   = "balmy-tokenizer-321318"
  credentials = "E:\\balmy-tokenizer-321318-0c66f882cadf.json"
}

module "gcp_create_instance" {
    source = "./modules/gcp_create_instance"
}

module "gcp_create_lb" {
    source = "./modules/gcp_create_lb"

    instance_group_id = module.gcp_create_instance.instance_group_id
}

module "gcp_create_sql" {
    source = "./modules/gcp_create_sql"

    instances = module.gcp_create_instance.instances
    db_password = var.db_password
}