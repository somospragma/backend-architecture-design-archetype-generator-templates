package ${packageName};

import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.graphql.data.method.annotation.SubscriptionMapping;
import org.springframework.stereotype.Controller;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.time.Duration;

/**
 * GraphQL Controller for ${adapterName}.
 * Handles GraphQL queries, mutations, and subscriptions reactively.
 */
@Controller
public class ${adapterName}GraphQLController {

    /**
     * Example query that returns a single item.
     * Maps to: query { getItem(id: "123") { id, name } }
     */
    @QueryMapping
    public Mono<${adapterName}Item> getItem(@Argument String id) {
        // TODO: Implement your business logic here
        return Mono.just(new ${adapterName}Item(id, "Sample Item"));
    }

    /**
     * Example query that returns a list of items.
     * Maps to: query { getAllItems { id, name } }
     */
    @QueryMapping
    public Flux<${adapterName}Item> getAllItems() {
        // TODO: Implement your business logic here
        return Flux.just(
                new ${adapterName}Item("1", "Item 1"),
                new ${adapterName}Item("2", "Item 2"),
                new ${adapterName}Item("3", "Item 3")
        );
    }

    /**
     * Example query with multiple arguments.
     * Maps to: query { searchItems(name: "test", limit: 10) { id, name } }
     */
    @QueryMapping
    public Flux<${adapterName}Item> searchItems(@Argument String name, @Argument Integer limit) {
        // TODO: Implement your business logic here
        return Flux.range(1, limit != null ? limit : 10)
                .map(i -> new ${adapterName}Item(String.valueOf(i), name + " " + i));
    }

    /**
     * Example mutation that creates an item.
     * Maps to: mutation { createItem(input: { name: "New Item" }) { id, name } }
     */
    @MutationMapping
    public Mono<${adapterName}Item> createItem(@Argument ${adapterName}ItemInput input) {
        // TODO: Implement your business logic here
        return Mono.just(new ${adapterName}Item("new-id", input.getName()));
    }

    /**
     * Example mutation that updates an item.
     * Maps to: mutation { updateItem(id: "123", input: { name: "Updated" }) { id, name } }
     */
    @MutationMapping
    public Mono<${adapterName}Item> updateItem(@Argument String id, @Argument ${adapterName}ItemInput input) {
        // TODO: Implement your business logic here
        return Mono.just(new ${adapterName}Item(id, input.getName()));
    }

    /**
     * Example mutation that deletes an item.
     * Maps to: mutation { deleteItem(id: "123") }
     */
    @MutationMapping
    public Mono<Boolean> deleteItem(@Argument String id) {
        // TODO: Implement your business logic here
        return Mono.just(true);
    }

    /**
     * Example subscription that streams items.
     * Maps to: subscription { itemUpdates { id, name } }
     */
    @SubscriptionMapping
    public Flux<${adapterName}Item> itemUpdates() {
        // TODO: Implement your business logic here
        // This example emits an item every second
        return Flux.interval(Duration.ofSeconds(1))
                .map(i -> new ${adapterName}Item(String.valueOf(i), "Item " + i));
    }

    /**
     * Example subscription with argument.
     * Maps to: subscription { itemUpdatesById(id: "123") { id, name } }
     */
    @SubscriptionMapping
    public Flux<${adapterName}Item> itemUpdatesById(@Argument String id) {
        // TODO: Implement your business logic here
        return Flux.interval(Duration.ofSeconds(1))
                .map(i -> new ${adapterName}Item(id, "Updated Item " + i));
    }

    // DTOs

    public record ${adapterName}Item(String id, String name) {}

    public record ${adapterName}ItemInput(String name) {
        public String getName() {
            return name;
        }
    }
}
