aws:
  dynamodb:
    region: us-east-1
    endpoint: # Leave empty for AWS, set for LocalStack (e.g., http://localhost:4566)
    access-key: # AWS access key (optional if using IAM roles)
    secret-key: # AWS secret key (optional if using IAM roles)

logging:
  level:
    software.amazon.awssdk.services.dynamodb: DEBUG
