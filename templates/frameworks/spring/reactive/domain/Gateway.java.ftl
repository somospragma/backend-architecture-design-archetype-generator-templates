package ${portsPackage};

/**
 * Output port for ${entityName}: what the domain needs from the outside world
 * (persistence, messaging, external APIs). Driven adapters implement it and use
 * cases depend on it, never on the adapters.
 *
 * Generated empty the first time a driven adapter for ${entityName} is created;
 * declare here the operations your use cases need, for example:
 *
 *   Mono<${entityName}> save(${entityName} ${entityName?uncap_first});
 *   Mono<${entityName}> findById(String id);
 */
public interface I${entityName}Gateway {
}
