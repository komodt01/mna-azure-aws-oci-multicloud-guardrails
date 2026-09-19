terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 5.40.0"
    }

    time = {
      source  = "hashicorp/time"
      version = ">= 0.9.0"
    }
  }
}

provider "oci" {
  region              = var.region
  config_file_profile = "DEFAULT"
}

provider "time" {}
