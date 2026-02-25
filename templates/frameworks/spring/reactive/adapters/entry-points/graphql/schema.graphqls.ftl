# GraphQL Schema for ${adapterName}

type Query {
    """
    Get a single item by ID
    """
    getItem(id: ID!): ${adapterName}Item

    """
    Get all items
    """
    getAllItems: [${adapterName}Item!]!

    """
    Search items by name with optional limit
    """
    searchItems(name: String!, limit: Int): [${adapterName}Item!]!
}

type Mutation {
    """
    Create a new item
    """
    createItem(input: ${adapterName}ItemInput!): ${adapterName}Item!

    """
    Update an existing item
    """
    updateItem(id: ID!, input: ${adapterName}ItemInput!): ${adapterName}Item!

    """
    Delete an item by ID
    """
    deleteItem(id: ID!): Boolean!
}

type Subscription {
    """
    Subscribe to item updates
    """
    itemUpdates: ${adapterName}Item!

    """
    Subscribe to updates for a specific item
    """
    itemUpdatesById(id: ID!): ${adapterName}Item!
}

"""
Represents an item in the system
"""
type ${adapterName}Item {
    id: ID!
    name: String!
}

"""
Input for creating or updating an item
"""
input ${adapterName}ItemInput {
    name: String!
}
