provider "aws" {
  region = var.region  
}

resource "aws_api_gateway_rest_api" "example" {
  name        = "example-api"
  description = "Example API Gateway REST API"
  
  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_resource" "items" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  parent_id   = aws_api_gateway_rest_api.example.root_resource_id
  path_part   = "items"
}

resource "aws_api_gateway_method" "example" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  resource_id   = aws_api_gateway_resource.items.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "root" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  resource_id   = aws_api_gateway_rest_api.example.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "example" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.items.id
  http_method = aws_api_gateway_method.example.http_method
  type        = "MOCK"
  
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration" "root" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_rest_api.example.root_resource_id
  http_method = aws_api_gateway_method.root.http_method
  type        = "MOCK"
  
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "example" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.items.id
  http_method = aws_api_gateway_method.example.http_method
  status_code = "200"
  
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_method_response" "root" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_rest_api.example.root_resource_id
  http_method = aws_api_gateway_method.root.http_method
  status_code = "200"
  
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "example" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.items.id
  http_method = aws_api_gateway_method.example.http_method
  status_code = "200"
  
  response_templates = {
    "application/json" = jsonencode({
      message = "Successfully retrieved items"
    })
  }
}

resource "aws_api_gateway_integration_response" "root" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_rest_api.example.root_resource_id
  http_method = aws_api_gateway_method.root.http_method
  status_code = "200"
  
  response_templates = {
    "application/json" = jsonencode({
      message = "Welcome to the API Gateway"
    })
  }
}

resource "aws_api_gateway_deployment" "example" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_method.example.id,
      aws_api_gateway_integration.example.id,
      aws_api_gateway_method_response.example.id,
      aws_api_gateway_integration_response.example.id,
      aws_api_gateway_method.root.id,
      aws_api_gateway_integration.root.id,
      aws_api_gateway_method_response.root.id,
      aws_api_gateway_integration_response.root.id
    ]))
  }
}

resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.example.id
  rest_api_id   = aws_api_gateway_rest_api.example.id
  stage_name    = "dev"
}

output "api_id" {
  value = aws_api_gateway_rest_api.example.id
}

output "items_endpoint" {
  value = "https://${aws_api_gateway_rest_api.example.id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_stage.dev.stage_name}/items"
}

output "root_endpoint" {
  value = "https://${aws_api_gateway_rest_api.example.id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_stage.dev.stage_name}/"
}