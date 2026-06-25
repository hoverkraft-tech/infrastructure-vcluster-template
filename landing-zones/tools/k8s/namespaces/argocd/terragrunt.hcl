locals {
  global      = yamldecode(file(find_in_parent_folders("global.yaml")))
  env         = yamldecode(file(find_in_parent_folders("env.yaml")))
  kubeconfig  = "${get_repo_root()}/.secrets/${local.env.name}.kubeconfig"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "github.com/hoverkraft-tech/terraform-modules.git//k8s/k8s-namespace?ref=2.5.0"
}

# vcluster manifest must have been applied before creating the namespace
dependency "vcluster" {
  config_path         = "../../../output"
  skip_outputs = true

  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
  mock_outputs                            = {}
}

# we must have retrived the real kubeconfig before creating the namespace
dependency "kubeconfig" {
  config_path         = "../../wait-for-k8s"
  skip_outputs = true

  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
  mock_outputs                            = {}
}

inputs = {
  name        = "argocd"
  kubeconfig  = local.kubeconfig
}
