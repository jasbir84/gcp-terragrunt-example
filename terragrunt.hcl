
locals {
  project  = "jasbirtestproj"
  region = "asia-southeast1"
}

inputs = {
  project = local.project
  region = local.region
  vpc_name  = "rke-demo-vpc"
  boot_disk_image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20230104"

  gce_manager_service_account = "gce-manager@${local.project}.iam.gserviceaccount.com"
  gce_rke_service_account = "gce-rke@${local.project}.iam.gserviceaccount.com"

  rke_manager_ip = "10.10.1.100"    
}

################################## Common ########################################

remote_state {
 backend = "gcs" 
 config = {
   bucket = "${local.project}-tf"
   prefix = path_relative_to_include()
   project = "${local.project}"
   location = "${local.region}"
 }
}

generate "provider" {
  path = "provider.tf"

  if_exists = "overwrite_terragrunt"

  contents = <<EOF
provider "google" {
  project     = "${local.project}"
  region      = "${local.region}"
}

terraform {
  backend "gcs" {}
  required_providers {
    google = "4.10.0"
  }  
}
EOF
}
