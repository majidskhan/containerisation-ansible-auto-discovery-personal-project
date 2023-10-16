provider "aws" {
  region  = "eu-west-3" #data.vault_generic_secret.aws-cred.data["region"]
}