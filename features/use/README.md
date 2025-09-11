# Use Property in API Simulations

This document demonstrates the `use` property in Tricentis API simulations, which enables referencing and reusing steps from template services. This powerful feature promotes code reusability and maintainability by allowing common workflows to be defined once and used across multiple services.

## Overview

The `use` property allows you to reference predefined service templates and incorporate their steps into your current service. This is particularly useful for:

- **Common authentication flows** (OAuth, JWT token generation, API key validation)
- **Shared validation logic** (input sanitization, format checking)
- **Reusable data transformation steps** (formatting, encoding, calculations)
- **Standard error handling patterns** (timeout responses, validation errors)

## How It Works

1. **Define Templates**: Create service templates in the `templates` section of a simulation file
2. **Include Templates**: Reference template files using the `includes` property
3. **Use Templates**: Reference template services by name using the `use` property in service steps
4. **Buffer Inheritance**: Buffers created in template steps become available in the calling service

## Template Definition

Templates are defined in the `templates` section of a simulation file:

```yaml
templates:
  services:
    - name: OAuth template
      steps:
        - to: auth-server
          insert:
            - value: 'client_credentials'
        - buffer:
            - name: token
              value: '{RANDOMREGEX["^[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}$"]}'
```

## Using Templates

Reference templates in your service steps using the `use` property:

```yaml
services:
  - name: OAuth test
    steps:
      - use: OAuth template  # Execute all steps from the template
      - to: api-endpoint
        insert:
          - value: "Bearer {B[token]}"  # Use buffer from template
```

## Buffer Inheritance

**Key Feature**: Buffers created in template steps are automatically available in the calling service.

In the example above:
- The `OAuth template` creates a buffer named `token`
- The calling service can access this buffer using `{B[token]}`
- This enables seamless data flow from templates to services

## File Organization

The use property works with the `includes` feature for better organization:

### templates.yml
```yaml
schema: SimV1
name: templates

templates:
  services:
    - name: OAuth template
      steps:
        - to: auth-server
          message:
            payload: '{"grant_type": "client_credentials"}'
        - buffer:
            - name: token
              jsonPath: access_token
```

### main-simulation.yml
```yaml
schema: SimV1
name: main-simulation

includes:
  - templates  # Include template definitions

services:
  - name: protected-api
    steps:
      - use: OAuth template  # Reference template by name
      - to: protected-endpoint
        message:
          headers:
            - key: Authorization
              value: "Bearer {B[token]}"
```

## Common Use Cases

### 1. OAuth Authentication Flow

**Template Definition:**
```yaml
templates:
  services:
    - name: OAuth flow
      steps:
        - to: oauth-server
          message:
            payload: |
              {
                "grant_type": "client_credentials",
                "client_id": "{VAR[clientId]}",
                "client_secret": "{VAR[clientSecret]}"
              }
        - buffer:
            - name: accessToken
              jsonPath: access_token
            - name: tokenType
              jsonPath: token_type
```

**Usage:**
```yaml
services:
  - name: user-service
    steps:
      - use: OAuth flow
      - to: user-api
        message:
          headers:
            - key: Authorization
              value: "{B[tokenType]} {B[accessToken]}"
```

### 2. Input Validation Template

**Template Definition:**
```yaml
templates:
  services:
    - name: validate-user-input
      steps:
        - verify:
            - jsonPath: email
              value: '{REGEX["^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"]}'
            - jsonPath: phone
              value: '{REGEX["^\+?[1-9]\d{1,14}$"]}'
        - buffer:
            - name: validationStatus
              value: "passed"
```

**Usage:**
```yaml
services:
  - name: user-registration
    steps:
      - direction: In
        trigger:
          - uri: /register
      - use: validate-user-input
      - direction: Out
        message:
          payload: '{"status": "success", "validation": "{B[validationStatus]}"}'
```

### 3. Error Handling Template

**Template Definition:**
```yaml
templates:
  services:
    - name: standard-error-response
      steps:
        - buffer:
            - name: errorCode
              value: "400"
            - name: errorMessage
              value: "Bad Request"
            - name: timestamp
              value: "{date}"
```

**Usage:**
```yaml
services:
  - name: api-endpoint
    steps:
      - direction: In
        trigger:
          - uri: /api/data
        verify:
          - jsonPath: requiredField
            exists: true
      - use: standard-error-response  # Use on validation failure
      - direction: Out
        message:
          statusCode: '{B[errorCode]}'
          payload: |
            {
              "error": "{B[errorMessage]}",
              "timestamp": "{B[timestamp]}"
            }
```

## Example Simulation

The files in this directory demonstrate:

### templates.yml
- Defines an OAuth template that generates a random token
- Creates a buffer named `token` for use by calling services

### use.yml
- Includes the templates file
- Uses the OAuth template in a service
- Accesses the `token` buffer created by the template
- Demonstrates buffer inheritance between template and service

## Benefits of Using Templates

1. **Code Reusability**: Define common patterns once, use everywhere
2. **Maintainability**: Update shared logic in one place
3. **Consistency**: Ensure uniform behavior across services
4. **Modularity**: Separate concerns into focused, reusable components
5. **Buffer Sharing**: Seamless data flow from templates to services

## Best Practices

1. **Logical Grouping**: Create templates for logically related steps
2. **Clear Naming**: Use descriptive names for templates and buffers
3. **Documentation**: Document template parameters and expected buffers
4. **File Organization**: Keep templates in separate files for better organization
5. **Buffer Management**: Use consistent buffer naming conventions
6. **Error Handling**: Include error handling in templates where appropriate

## Template vs Include

| Feature | Purpose | Scope |
|---------|---------|-------|
| `includes` | Import entire simulation files | File-level inclusion |
| `use` | Reference specific template services | Step-level template usage |
| **Combined** | Include template files, then use specific templates | Maximum flexibility and organization |

## Running the Example

1. Deploy both `templates.yml` and `use.yml` to a simulator agent
2. The `use.yml` simulation will:
   - Execute the OAuth template steps
   - Generate a random token and store it in a buffer
   - Use the token in subsequent steps
   - Verify the token format using regex validation

## Advanced Patterns

### Nested Template Usage
Templates can reference other templates, enabling complex reusable workflows:

```yaml
templates:
  services:
    - name: base-auth
      steps:
        - buffer:
            - name: timestamp
              value: "{date}"
    
    - name: oauth-with-logging
      steps:
        - use: base-auth
        - to: auth-server
          message:
            payload: '{"timestamp": "{B[timestamp]}"}'
```

The use property enables powerful composition patterns that make API simulations more maintainable and reusable across complex scenarios.
