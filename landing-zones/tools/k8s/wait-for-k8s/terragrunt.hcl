locals {
  global            = yamldecode(file(find_in_parent_folders("global.yaml")))
  env               = yamldecode(file(find_in_parent_folders("env.yaml")))
  remote_kubeconfig = "${local.global.sharedFolder.kubeconfigFiles.basePath}/${local.global.customer.name}/${local.env.name}.kubeconfig"
  local_kubeconfig  = "${get_repo_root()}/.secrets/${local.env.name}.kubeconfig"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "github.com/hoverkraft-tech/terraform-modules.git//misc/null?ref=2.5.1"

  # Wait for the kubeconfig file to be available before creating the namespace
  before_hook "wait_for_kubeconfig" {
    commands = ["apply"]
    execute = [
      "bash",
      "${get_repo_root()}/scripts/wait-for-file.sh",
      "${local.remote_kubeconfig}"
    ]
  }

  before_hook "copy_file" {
    commands = ["apply"]
    execute = [
      "cp",
      "${local.remote_kubeconfig}",
      "${local.local_kubeconfig}"
    ]
  }
}

# vcluster manifest must be available before creating the namespace
dependency "vcluster" {
  config_path  = "../../output"
  skip_outputs = true

  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "providers"]
  mock_outputs                            = {}
}

inputs = {
  name = local.env.name
}
