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

dependency "argocd" {
  config_path  = "../core"
  skip_outputs = true

  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "providers"]
  mock_outputs = {
  }
}

inputs = {
  name             = "argocd-apps"
  chart            = "argocd-apps"
  repository       = local.env.helm.argocd-apps.repository
  chart_version    = local.env.helm.argocd-apps.chart_version
  customer         = local.global.customer.name
  environment      = local.env.name
  namespace        = local.env.helm.argocd.namespace
  kubeconfig_paths = [local.kubeconfig]
  values = [templatefile(
    "${get_terragrunt_dir()}/values.tpl.yaml",
    { repo_url = local.env.helm.argocd-apps.source-of-truth.url }
  )]
}
