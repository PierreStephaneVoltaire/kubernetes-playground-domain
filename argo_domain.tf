locals {
  argo_domain = "argocd.${var.domain_name}"
}

data "aws_route53_zone" "main" {
  name = var.domain_name
}



data "aws_elb" "argo" {
  name = "a25e3f517090b4c0d9c10f0254a8928b"
}

resource "aws_route53_record" "argocd_alb" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = local.argo_domain
  type    = "A"
  alias {
    name                   = data.aws_elb.argo.dns_name
    zone_id                = data.aws_elb.argo.zone_id
    evaluate_target_health = true
  }
}