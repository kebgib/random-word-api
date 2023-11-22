resource "aws_api_gateway_rest_api" "apigw" {
  name        = "random-word-rest-api-gateway"
  description = "Random word REST API Gateway"
}
# This stage name will be assocated with the AWS WAF integration
resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  stage_name    = "api"
}
# /api/v1/
resource "aws_api_gateway_resource" "v1" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_rest_api.apigw.root_resource_id
  path_part   = "v1"
}
# /api/v1/word
resource "aws_api_gateway_resource" "word" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "word"
}

resource "aws_api_gateway_method" "method_proxy" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.word.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.word.id
  http_method             = aws_api_gateway_method.method_proxy.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_handler.invoke_arn
}

# An API Gateway deployment must not specify the stage_name parameter.
# Use the aws_api_gateway_stage resource to associate a stage with a deployment
# then use the stage.arn attribute to associate with a WAF
resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration
  ]
  rest_api_id = aws_api_gateway_rest_api.apigw.id
}

resource "aws_lambda_permission" "apigw_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_handler.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.apigw.execution_arn}/*/*"
}