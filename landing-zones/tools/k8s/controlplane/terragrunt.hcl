locals {
  global = yamldecode(file(find_in_parent_folders("global.yaml")))
  env    = yamldecode(file(find_in_parent_folders("env.yaml")))
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "github.com/hoverkraft-tech/terraform-modules.git//k8s/helm-template?ref=2.5.0"
}

inputs = {
  name = "vcluster"
  namespace = "${local.global.customer.slug}-${local.env.name}"
  repository = "https://charts.loft.sh"
  chart = "vcluster"
  chart_version = local.env.vcluster.version

  values = [
    templatefile("values.yaml", {
      ctx_name      = local.env.name,
      lb_ip         = local.env.vcluster.loadBalancerIp,
      storage_class = local.env.vcluster.storageClass,
      sts_req_mem   = local.env.vcluster.sts.memory.request,
      sts_lim_mem   = local.env.vcluster.sts.memory.limit,
    })
  ]
}
