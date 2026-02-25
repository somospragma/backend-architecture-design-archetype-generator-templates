package ${packageName};

import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;

/**
 * GraphQL Controller for ${adapterName}.
 * Handles GraphQL queries and mutations synchronously.
 */
@Controller
public class ${adapterName}GraphQLController {

    /**
     * Example query that returns a single item.
     * Maps to: query { getItem(id: "123") { id, name } }
     */
    @QueryMapping
    public ${adapterName}Item getItem(@Argument String id) {
        // TODO: Implement your business logic here
        return new ${adapterName}Item(id, "Sample Item");
    }

    /**
     * Example query that returns a list of items.
     * Maps to: query { getAllItems { id, name } }
     */
    @QueryMapping
    public List<${adapterName}Item> getAllItems() {
        // TODO: Implement your business logic here
        return List.of(
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
    public List<${adapterName}Item> searchItems(@Argument String name, @Argument Integer limit) {
        // TODO: Implement your business logic here
        int itemLimit = limit != null ? limit : 10;
        return java.util.stream.IntStream.range(1, itemLimit + 1)
                .mapToObj(i -> new ${adapterName}Item(String.valueOf(i), name + " " + i))
                .toList();
    }

    /**
     * Example mutation that creates an item.
     * Maps to: mutation { createItem(input: { name: "New Item" }) { id, name } }
     */
    @MutationMapping
    public ${adapterName}Item createItem(@Argument ${adapterName}ItemInput input) {
        // TODO: Implement your business logic here
        return new ${adapterName}Item("new-id", input.getName());
    }

    /**
     * Example mutation that updates an item.
     * Maps to: mutation { updateItem(id: "123", input: { name: "Updated" }) { id, name } }
     */
    @MutationMapping
    public ${adapterName}Item updateItem(@Argument String id, @Argument ${adapterName}ItemInput input) {
        // TODO: Implement your business logic here
        return new ${adapterName}Item(id, input.getName());
    }

    /**
     * Example mutation that deletes an item.
     * Maps to: mutation { deleteItem(id: "123") }
     */
    @MutationMapping
    public Boolean deleteItem(@Argument String id) {
        // TODO: Implement your business logic here
        return true;
    }

    // DTOs

    public record ${adapterName}Item(String id, String name) {}

    public record ${adapterName}ItemInput(String name) {
        public String getName() {
            return name;
        }
    }
}
