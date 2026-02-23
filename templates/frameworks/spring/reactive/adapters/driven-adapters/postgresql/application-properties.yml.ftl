spring:
  r2dbc:
    url: r2dbc:postgresql://localhost:5432/${projectName?lower_case}
    username: postgres
    password: postgres
  data:
    r2dbc:
      repositories:
        enabled: true

logging:
  level:
    io.r2dbc.postgresql.QUERY: DEBUG
    io.r2dbc.postgresql.PARAM: DEBUG
