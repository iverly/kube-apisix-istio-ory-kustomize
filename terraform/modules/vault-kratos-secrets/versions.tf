terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.23.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }
}
