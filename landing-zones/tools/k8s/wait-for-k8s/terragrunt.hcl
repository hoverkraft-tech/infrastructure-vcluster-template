locals {
  global = yamldecode(file(find_in_parent_folders("global.yaml")))
  env    = yamldecode(file(find_in_parent_folders("env.yaml")))
  remote_kubeconfig = "${local.global.sharedFolder.kubeconfigFiles.basePath}/${local.global.customer.name}/${local.env.name}.kubeconfig}"
  local_kubeconfig  = "${get_repo_root()}/.secrets/${local.env.name}.kubeconfig"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  # Wait for the kubeconfig file to be available before creating the namespace
  before_hook "wait_for_kubeconfig" {
    commands = ["plan", "apply"]
    execute    = [
      "bash",
      "./scripts/wait-for-file.sh",
      "${local.remote_kubeconfig}"
    ]
  }

  before_hook "copy_file" {
    commands = ["plan", "apply"]
    execute    = [
      "cp",
      "${local.remote_kubeconfig}",
      "${local.local_kubeconfig}"
    ]
  }
}

# vcluster manifest must be available before creating the namespace
dependency "vcluster" {
  config_path         = "../../output"
  skip_outputs = true

  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
  mock_outputs                            = {}
}
