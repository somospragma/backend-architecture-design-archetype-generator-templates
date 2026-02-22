spring:
  data:
    mongodb:
      uri: mongodb://localhost:27017/${projectName}
      # WARNING: Do not store credentials in source control
      # Use environment variables or secret management in production
      database: ${projectName}
      auto-index-creation: true
