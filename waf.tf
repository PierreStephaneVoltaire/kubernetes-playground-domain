resource "aws_wafv2_web_acl" "default_waf" {
  name        = "default-waf"
  description = "Basic AWS WAF with enhanced managed rules"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 0

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }


  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "basic-waf-metrics"
    sampled_requests_enabled   = false
  }
}
data "aws_lbs" "all" {}
resource "aws_wafv2_web_acl_association" "alb_assoc" {
  for_each     = toset(data.aws_lbs.all.arns)
  resource_arn = each.value
  web_acl_arn  = aws_wafv2_web_acl.default_waf.arn
}
#
# resource "aws_wafv2_web_acl_association" "eks_assoc" {
#   count        = var.attach_eks ? 1 : 0
#   resource_arn = var.eks_control_plane_arn
#   web_acl_arn  = aws_wafv2_web_acl.basic_waf.arn
# }
