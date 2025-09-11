# Tree Property in API Simulations

This document demonstrates the use of the `tree` property in Tricentis API simulations, which allows you to insert or verify entire JSON or XML tree structures.

## Overview

The `tree` property is a powerful feature that enables you to work with complex nested data structures as complete units, rather than manipulating individual values. Unlike the `value` property that modifies a single element specified by a path, the `tree` property replaces the entire content at the specified path with a complete hierarchical structure.

## What is a Tree?

In the context of JSON and XML, a **tree** refers to a hierarchical data structure where:
- **JSON Tree**: A nested object or array structure containing multiple levels of properties, objects, and arrays
- **XML Tree**: A nested element structure with parent-child relationships, attributes, and text content

Trees represent complex data relationships and are commonly used for:
- User profiles with nested preferences
- Configuration objects with multiple sections
- Document metadata with hierarchical organization
- API responses with nested resource relationships

## Tree vs Value Property

| Property | Purpose | Scope |
|----------|---------|--------|
| `value` | Modifies a single element's content | Single value or simple string |
| `tree` | Replaces entire structure at specified path | Complete nested object/element hierarchy |

## JSON Tree Examples

### Simple JSON Tree
```json
{
  "user": {
    "name": "John Doe",
    "preferences": {
      "theme": "dark",
      "notifications": true
    }
  }
}
```

### Complex JSON Tree
```json
{
  "profile": {
    "personal": {
      "firstName": "John",
      "lastName": "Doe",
      "address": {
        "street": "123 Main St",
        "city": "Springfield",
        "coordinates": {
          "lat": 40.7128,
          "lng": -74.0060
        }
      }
    },
    "preferences": {
      "privacy": {
        "profileVisible": true,
        "shareData": false
      },
      "notifications": {
        "email": true,
        "push": false,
        "sms": true
      }
    }
  }
}
```

## XML Tree Examples

### Simple XML Tree
```xml
<metadata>
  <title>Sample Document</title>
  <author>API Simulation</author>
  <tags>
    <tag>example</tag>
    <tag>simulation</tag>
  </tags>
</metadata>
```

### Complex XML Tree
```xml
<document>
  <header>
    <metadata>
      <title>Complex Document</title>
      <author>
        <name>John Doe</name>
        <email>john@example.com</email>
      </author>
      <created>2024-01-01T10:00:00Z</created>
    </metadata>
    <classification>
      <level>public</level>
      <categories>
        <category>documentation</category>
        <category>example</category>
      </categories>
    </classification>
  </header>
  <content>
    <section id="intro">
      <title>Introduction</title>
      <paragraph>This is an example document.</paragraph>
    </section>
  </content>
</document>
```

## Usage in Simulations

The `tree` property can be used in three main contexts:

### 1. Insert Operations (Response Generation)
Replace a placeholder with a complete tree structure:

```yaml
insert:
  - jsonPath: profile
    tree: |
      "{
        ""firstName"": ""John"",
        ""lastName"": ""Doe"",
        ""address"": {
          ""street"": ""123 Main St"",
          ""city"": ""Springfield""
        }
      }"
```

### 2. Verification Operations (Request Validation)
Verify that incoming data matches an expected tree structure:

```yaml
verify:
  - jsonPath: data.structure
    tree: |
      "{
        ""type"": ""complex"",
        ""nested"": {
          ""level1"": {
            ""level2"": {
              ""value"": ""expected""
            }
          }
        }
      }"
```

## Example Simulation

The `tree.yml` file in this directory demonstrates:

1. **User Profile Service**: Shows how to insert complex JSON trees for user profiles and preferences
2. **XML Document Service**: Demonstrates XML tree insertion for document metadata
3. **Verification Service**: Illustrates how to verify incoming requests against expected tree structures

## Benefits of Using Tree Property

1. **Structure Integrity**: Ensures complete hierarchical structures are maintained
2. **Reduced Complexity**: Avoid multiple individual `value` insertions for related data
3. **Template Reusability**: Define complex structures once and reuse them
4. **Validation Power**: Verify entire data structures in single operations
5. **Maintainability**: Easier to manage complex nested data as cohesive units

## Best Practices

1. **Use for Related Data**: Group logically related properties into tree structures
2. **Validate Structure**: Use tree verification for complex request validation
3. **Template Complex Responses**: Create reusable tree templates for common response patterns
4. **Combine with Variables**: Use variables within tree structures for dynamic content
5. **Format Consistently**: Maintain consistent indentation and formatting in tree definitions

## Running the Example

1. Deploy the `tree.yml` simulation to a simulator agent
2. Test the endpoints:
   - `POST /api/users/profile` - See JSON tree insertion
   - `POST /api/documents/create` - See XML tree insertion  
   - `POST /api/verify` - Test tree structure verification

The simulation demonstrates how tree properties enable powerful manipulation of complex nested data structures in API simulations.
