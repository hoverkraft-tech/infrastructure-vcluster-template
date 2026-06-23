locals {
  global = yamldecode(file(find_in_parent_folders("global.yaml")))
  env    = yamldecode(file(find_in_parent_folders("env.yaml")))
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "github.com/hoverkraft-tech/terraform-modules.git//k8s/k8s-namespace?ref=2.5.0"

  # Wait for the kubeconfig file to be available before creating the namespace
  before_hook "wait_for_file" {
    commands = ["plan", "apply"]
    execute    = [
      "bash",
      "./scripts/wait-for-file.sh",
      "${local.global.sharedFolder.kubeconfigFiles.basePath}/${local.global.customer.name}/${local.env.name}.kubeconfig"
    ]
  }
}

# vcluster manifest must be available before creating the namespace
dependency "vcluster" {
  config_path         = "../../../output"
  skip_outputs = true

  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
  mock_outputs                            = {}
}

inputs = {
  name = "argocd"
}
