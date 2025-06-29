# AWS API Gateway Terraform Project

This Terraform project provisions a simple AWS API Gateway with two mock endpoints.

## Overview

This project creates an AWS API Gateway with the following resources:
- REST API with two endpoints: `/` and `/items`
- Mock integrations for both endpoints
- Response templates for JSON responses

## Requirements

- Terraform >= 1.0.0
- AWS CLI configured with appropriate credentials
- AWS account with necessary permissions

## Configuration

The project uses the following variables (defined in `variables.tf`):

- `region`: AWS region where the API Gateway will be deployed (default: "ap-northeast-1")
- `AK`: Environment variable (default: "dev")

## Usage

1. Initialize Terraform:
```bash
terraform init
```

2. Plan the deployment:
```bash
terraform plan
```

3. Apply the configuration:
```bash
terraform apply
```

## API Endpoints

After deployment, the API Gateway will have two endpoints:

1. Root endpoint (`/`):
   - HTTP Method: GET
   - Response: "Welcome to the API Gateway"

2. Items endpoint (`/items`):
   - HTTP Method: GET
   - Response: "Successfully retrieved items"

You can test the endpoints using curl or any HTTP client. The base URL will be available in the Terraform output after deployment.

## Outputs

The following outputs will be available after deployment:
- `api_url`: The base URL of the deployed API Gateway
- `root_endpoint_url`: Full URL for the root endpoint
- `items_endpoint_url`: Full URL for the items endpoint

## Cleanup

To destroy all created resources:
```bash
terraform destroy
```

## Security

The API Gateway is configured with no authorization (public access). For production environments, consider implementing appropriate authentication mechanisms.

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
