locals {
  global     = yamldecode(file(find_in_parent_folders("global.yaml")))
  env        = yamldecode(file(find_in_parent_folders("env.yaml")))
  kubeconfig = "${get_repo_root()}/.secrets/${local.env.name}.kubeconfig"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "github.com/hoverkraft-tech/terraform-modules.git//k8s/helm-release?ref=2.5.0"
}

dependency "namespace" {
  config_path = "../../../namespaces/argocd"

  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
  mock_outputs = {
    name = "argocd"
  }
}

inputs = {
  name             = "argocd"
  chart            = "argo-cd"
  repository       = local.env.helm.argocd.repository
  chart_version    = local.env.helm.argocd.chart_version
  customer         = local.global.customer.name
  environment      = local.env.name
  namespace        = local.env.helm.argocd.namespace
  kubeconfig_paths = [local.kubeconfig]
  values = [
    file("${get_terragrunt_dir()}/values.yaml")
  ]
}
