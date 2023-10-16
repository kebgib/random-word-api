variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-2"
}
variable "waf_regionality" {
  description = "AWS WAF Region type: REGIONAL or CLOUDFRONT"
  type        = string
  default     = "REGIONAL"
}