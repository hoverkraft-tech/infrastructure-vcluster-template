locals {
  global = yamldecode(file(find_in_parent_folders("global.yaml")))
  env    = yamldecode(file(find_in_parent_folders("env.yaml")))
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "github.com/hoverkraft-tech/terraform-modules.git//outputs/local-file?ref=2.5.0"
}

dependency "helm" {
  config_path                             = "../k8s/controlplane"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
  mock_outputs = {
    manifest   = "xxxxxxxxxxxxxxxxxxxx"
  }
}

inputs = {
  name = "vcluster manifest"
  filename = "${local.global.shared_folder.path}/${local.env.name}.yaml"
  content = dependency.helm.outputs.manifest
}
