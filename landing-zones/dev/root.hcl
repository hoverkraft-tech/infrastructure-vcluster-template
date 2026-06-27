locals {
  global = yamldecode(file(find_in_parent_folders("global.yaml")))
  env    = yamldecode(file("env.yaml"))
}

generate "provider" {
  path      = "providers.tf"
  if_exists = "overwrite"
  contents  = <<EOF

terraform {
  required_version = "~> 1.3"

  required_providers {
    local      = "~> 2.3.0"
    tls        = "~> 4.0.4"
    time       = "~> 0.9.1"
    helm       = "~> 2.17.0"
    kubernetes = "~> 2.17.0"
    pass =  {
      source  = "mecodia/pass"
      version = "~> 3.1.0"
    }
  }
}

EOF
}
