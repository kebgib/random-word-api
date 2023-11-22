output "lambda_bucket_name" {
  description = "The name of the bucket."
  value       = aws_s3_bucket.lambda_bucket.id
}
output "function_name" {
  description = "The name of the function."
  value       = aws_lambda_function.lambda_handler.function_name
}
output "helper_cli_command" {
  description = "The command to run to invoke the function."
  value       = "aws lambda invoke --function-name ${aws_lambda_function.lambda_handler.function_name} results.json"
}

output "api_endpoint" {
  description = "The endpoint for the API."
  value       = "${aws_api_gateway_deployment.deployment.invoke_url}${aws_api_gateway_stage.stage.stage_name}/${aws_api_gateway_resource.v1.path_part}/${aws_api_gateway_resource.word.path_part}"
}