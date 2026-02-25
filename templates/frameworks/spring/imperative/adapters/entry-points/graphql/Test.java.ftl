package ${packageName};

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.graphql.tester.AutoConfigureGraphQlTester;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.graphql.test.tester.GraphQlTester;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Test for ${adapterName}GraphQLController
 */
@SpringBootTest
@AutoConfigureGraphQlTester
class ${adapterName}GraphQLControllerTest {

    @Autowired
    private GraphQlTester graphQlTester;

    @Test
    void testGetItem() {
        String query = """
                query {
                    getItem(id: "123") {
                        id
                        name
                    }
                }
                """;

        graphQlTester.document(query)
                .execute()
                .path("getItem")
                .entity(${adapterName}GraphQLController.${adapterName}Item.class)
                .satisfies(item -> {
                    assertThat(item.id()).isEqualTo("123");
                    assertThat(item.name()).isNotNull();
                });
    }

    @Test
    void testGetAllItems() {
        String query = """
                query {
                    getAllItems {
                        id
                        name
                    }
                }
                """;

        graphQlTester.document(query)
                .execute()
                .path("getAllItems")
                .entityList(${adapterName}GraphQLController.${adapterName}Item.class)
                .satisfies(items -> {
                    assertThat(items).isNotEmpty();
                    assertThat(items).hasSizeGreaterThan(0);
                });
    }

    @Test
    void testSearchItems() {
        String query = """
                query {
                    searchItems(name: "test", limit: 5) {
                        id
                        name
                    }
                }
                """;

        graphQlTester.document(query)
                .execute()
                .path("searchItems")
                .entityList(${adapterName}GraphQLController.${adapterName}Item.class)
                .satisfies(items -> {
                    assertThat(items).hasSize(5);
                    assertThat(items.get(0).name()).contains("test");
                });
    }

    @Test
    void testCreateItem() {
        String mutation = """
                mutation {
                    createItem(input: { name: "New Item" }) {
                        id
                        name
                    }
                }
                """;

        graphQlTester.document(mutation)
                .execute()
                .path("createItem")
                .entity(${adapterName}GraphQLController.${adapterName}Item.class)
                .satisfies(item -> {
                    assertThat(item.id()).isNotNull();
                    assertThat(item.name()).isEqualTo("New Item");
                });
    }

    @Test
    void testUpdateItem() {
        String mutation = """
                mutation {
                    updateItem(id: "123", input: { name: "Updated Item" }) {
                        id
                        name
                    }
                }
                """;

        graphQlTester.document(mutation)
                .execute()
                .path("updateItem")
                .entity(${adapterName}GraphQLController.${adapterName}Item.class)
                .satisfies(item -> {
                    assertThat(item.id()).isEqualTo("123");
                    assertThat(item.name()).isEqualTo("Updated Item");
                });
    }

    @Test
    void testDeleteItem() {
        String mutation = """
                mutation {
                    deleteItem(id: "123")
                }
                """;

        graphQlTester.document(mutation)
                .execute()
                .path("deleteItem")
                .entity(Boolean.class)
                .isEqualTo(true);
    }
}
