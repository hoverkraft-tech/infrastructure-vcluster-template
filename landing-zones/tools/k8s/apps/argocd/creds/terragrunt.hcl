locals {
  global     = yamldecode(file(find_in_parent_folders("global.yaml")))
  env        = yamldecode(file(find_in_parent_folders("env.yaml")))
  kubeconfig = "${get_repo_root()}/.secrets/${local.env.name}.kubeconfig"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "github.com/hoverkraft-tech/terraform-modules.git//k8s/k8s-secret?ref=2.5.0"
}

dependency "argocd" {
  config_path  = "../core"
  skip_outputs = true

  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
  mock_outputs                            = {}
}

dependency "argocd_private_key" {
  config_path                             = "../../../../secrets/argocd-private-key"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
  mock_outputs = {
    # checkov:skip=CKV_SECRET_13: this is only a mock
    password = "-----BEGIN OPENSSH PRIVATE KEY-----\nxxxxxxxxxxxxxxxxxxxx\n-----END OPENSSH PRIVATE KEY-----"
    full     = "-----BEGIN OPENSSH PRIVATE KEY-----\nxxxxxxxxxxxxxxxxxxxx\n-----END OPENSSH PRIVATE KEY-----"
  }
}

inputs = {
  name        = "app-of-the-apps-repo"
  customer    = local.global.customer.name
  environment = local.env.name
  config_path = local.kubeconfig
  namespace   = local.env.helm.argocd.namespace
  labels = {
    "app.kubernetes.io/name"         = "argocd"
    "argocd.argoproj.io/secret-type" = "repository"
  }
  data = {
    "type" : local.env.helm.argocd-app.source-of-truth.type,
    "url" : local.env.helm.argocd-app.source-of-truth.url,
    "sshPrivateKey" : dependency.argocd_private_key.outputs.full,
  }
}
