locals {
  jenkins_domain = "jenkins.${var.domain_name}"
}


data "aws_lbs" "jenkins" {
  tags = {
    "ingress.k8s.aws/stack" = "jenkins/jenkins"
  }
}
data "aws_lb" "jenkins" {
  arn = one(data.aws_lbs.jenkins.arns)
}
resource "aws_route53_record" "jenkins_alb" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = local.jenkins_domain
  type    = "A"
  alias {
    name                   = data.aws_lb.jenkins.dns_name
    zone_id                = data.aws_lb.jenkins.zone_id
    evaluate_target_health = true
  }
}