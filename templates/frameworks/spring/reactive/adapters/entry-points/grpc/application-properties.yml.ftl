grpc:
  server:
    port: 9090
    address: 0.0.0.0
    max-inbound-message-size: 4MB
    enable-keep-alive: true
    keep-alive-time: 30s
    keep-alive-timeout: 5s
    permit-keep-alive-without-calls: true

logging:
  level:
    net.devh.boot.grpc: DEBUG
    io.grpc: DEBUG
