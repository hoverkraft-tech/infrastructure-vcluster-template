locals {
  global = yamldecode(file(find_in_parent_folders("global.yaml")))
  env    = yamldecode(file(find_in_parent_folders("env.yaml")))
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "/Users/frederic/Documents/_work/119_hoverkraft-tech/src/terraform-modules//outputs/local-file"
  // source = "github.com/hoverkraft-tech/terraform-modules.git//k8s/helm-template?ref=2.1.4"
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
  filename = "${ get_env("SECRETS") }/${local.env.name}.yaml"
  content = dependency.helm.outputs.manifest
}
