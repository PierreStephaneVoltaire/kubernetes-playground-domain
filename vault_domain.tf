locals {
  vault_domain = "vault.${var.domain_name}"
}
data "aws_lbs" "vault" {
  tags = {
    "ingress.k8s.aws/stack" = "vault/vault"
  }
}

data "aws_lb" "vault" {
  arn = one(data.aws_lbs.vault.arns)
}
resource "aws_route53_record" "vaultcd_alb" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = local.vault_domain
  type    = "A"
  alias {
    name                   = data.aws_lb.vault.dns_name
    zone_id                = data.aws_lb.vault.zone_id
    evaluate_target_health = true
  }
}

