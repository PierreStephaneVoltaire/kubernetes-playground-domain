data "aws_lbs" "istio" {
  tags = {
    "service.k8s.aws/stack" = "istio-system/istio-ingressgateway"
  }
}

data "aws_lb" "istio" {
  arn = one(data.aws_lbs.istio.arns)
}
resource "aws_route53_record" "vault" {
  for_each = toset(["dev","uat","prod"])
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "vault-${each.value}.${var.domain_name}"
  type    = "A"
  alias {
    name                   = data.aws_lb.istio.dns_name
    zone_id                = data.aws_lb.istio.zone_id
    evaluate_target_health = true
  }
}

