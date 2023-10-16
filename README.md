# Random-Word-API
An AWS Serverless application written in Terraform that creates new words

These words might not be so good, but they are random.

## Getting Started
Clone the repository and run `terraform apply` to deploy the application
```bash
git clone git@github.com:kebgib/random-word-api.git
cd random-word-api
terraform apply
```
Use the terraform outputs to test your new API and start generating words
```python
Outputs:
api_endpoint = "https://example-execute-url.execute-api.us-west-2.amazonaws.com/prod/word"
helper_cli_command = "aws lambda invoke --function-name RandomWordGenerator results.json"
```