locals {
  global = yamldecode(file(find_in_parent_folders("global.yaml")))
  env    = yamldecode(file(find_in_parent_folders("env.yaml")))
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "github.com/hoverkraft-tech/terraform-modules.git//password-store/get?ref=2.5.0"
}

inputs = {
  path = local.env.password_store.argocd_admin_password_path
}
