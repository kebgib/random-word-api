resource "aws_wafv2_web_acl" "waf_acl" {
  name  = "random-word-api-waf"
  scope = var.waf_regionality

  default_action {
    allow {}
  }

  # COMMON RULES
  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 0
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    override_action {
      none {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }
  # REPUTATION RULES
  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 1
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }
    override_action {
      none {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }
  # BAD INPUTS RULES
  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 2
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }
    override_action {
      none {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }
  # SQLi RULES
  rule {
    name     = "AWS-AWSManagedRulesSQLiRuleSet"
    priority = 3
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }
    override_action {
      none {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesSQLiRuleSet"
      sampled_requests_enabled   = true
    }
  }
  # LINUX RULES
  rule {
    name     = "AWS-AWSManagedRulesLinuxRuleSet"
    priority = 4
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
      }
    }
    override_action {
      none {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesLinuxRuleSet"
      sampled_requests_enabled   = true
    }
  }
  # BOTS
  rule {
    name     = "AWS-AWSManagedRulesBotControlRuleSet"
    priority = 5
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"
      }
    }
    override_action {
      none {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesBotControlRuleSet"
      sampled_requests_enabled   = true
    }
  }
  # RATE LIMITING
  rule {
    name     = "Ratelimiting"
    priority = 6
    statement {
      rate_based_statement {
        aggregate_key_type = "IP"
        limit              = 100
      }
    }
    action {
      block {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "Ratelimiting"
      sampled_requests_enabled   = true
    }
  }
  tags = {
    Name      = "random-word-api-waf"
    Terraform = true
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "random-word-api-waf"
    sampled_requests_enabled   = true
  }
}

# Only API Gateway Stage can be assocated with WAF ACLs
resource "aws_wafv2_web_acl_association" "waf_association" {
  depends_on = [
    aws_api_gateway_stage.stage,
    aws_wafv2_web_acl.waf_acl
  ]
  resource_arn = aws_api_gateway_stage.stage.arn
  web_acl_arn  = aws_wafv2_web_acl.waf_acl.arn
}