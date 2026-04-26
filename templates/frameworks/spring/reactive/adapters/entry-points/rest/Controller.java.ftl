<#--
  DEPRECATED: This template has been replaced by the Router + Handler pattern.
  
  For reactive REST endpoints, use:
  - Router.java.ftl: Defines RouterFunction<ServerResponse> beans with path-based routing
  - Handler.java.ftl: Contains request handling methods (ServerRequest -> Mono<ServerResponse>)
  
  The @RestController pattern is not appropriate for reactive WebFlux applications
  per KB Limit 002. Use the functional endpoint model instead.
  
  This file is kept for backward compatibility but should not be used for new projects.
-->
<#stop "Controller.java.ftl is deprecated for reactive REST. Use Router.java.ftl and Handler.java.ftl instead.">
