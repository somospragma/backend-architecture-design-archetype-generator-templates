aws:
  sqs:
    consumer:
      region: us-east-1
      endpoint: # Leave empty for AWS, set for LocalStack (e.g., http://localhost:4566)
      queue-name: ${adapterName?lower_case}-queue
      access-key: # AWS access key (optional if using IAM roles)
      secret-key: # AWS secret key (optional if using IAM roles)
      max-concurrent-messages: 10
      poll-timeout: 10

spring:
  cloud:
    aws:
      sqs:
        enabled: true

logging:
  level:
    io.awspring.cloud.sqs: DEBUG
    software.amazon.awssdk.services.sqs: DEBUG
