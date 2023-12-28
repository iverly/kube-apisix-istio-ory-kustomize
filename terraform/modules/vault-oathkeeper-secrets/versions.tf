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

    jwks = {
      source  = "iwarapter/jwks"
      version = "0.1.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
  }
}
