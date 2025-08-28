# Variables in API Simulations

This document describes how to use variables in API simulations to make your simulations more flexible and configurable.

## Overview

Variables allow you to inject dynamic values into your API simulations at runtime. This enables you to:
- Reuse simulations across different environments
- Pass sensitive information like secrets without hardcoding them
- Configure simulation behavior without modifying YAML files

## Variable Declaration

Variables can be declared in two ways:

### 1. Configuration File (appsettings.yml)

Add variables to your `appsettings.yml` file under the `Simulator.Variables` section:

```yaml
Simulator:
  # Configure variables that can be used inside simulations
  # Access variables via 'var', e.g. '{var[User]}'
  Variables:
    User: John
    Environment: production
    BaseUrl: https://api.example.com
```

### 2. Command Line Arguments

Pass variables at startup using the `--variables` parameter:

```bash
# Single variable
Tricentis.Simulator.Agent.exe --variables user=john

# Multiple variables (comma-separated)
Tricentis.Simulator.Agent.exe --variables user=john,secret=test,env=dev

# Using environment variables for secrets
Tricentis.Simulator.Agent.exe --variables secret=%SECRET_FROM_KEYVAULT%
```

## Variable Usage in Simulations

Variables are accessed using the `{VAR[variable_name]}` syntax in your simulation YAML files.

### Example Usage

```yaml
schema: SimV1
name: variables-example

services:
  - name: api-service
    steps:
      - direction: In
        trigger:
          - uri: /api/{VAR[environment]}/users
      - direction: Out
        message:
          payload: '{"user": "{VAR[User]}", "workspace": "{VAR[workspace]}"}'
```

## Use Cases

### 1. Environment-Specific Configuration

```bash
# Development
Tricentis.Simulator.Agent.exe --variables env=dev,baseUrl=https://dev-api.example.com

# Production  
Tricentis.Simulator.Agent.exe --variables env=prod,baseUrl=https://api.example.com
```

### 2. Secret Management

Variables are particularly useful for handling sensitive information:

```bash
# Pass secrets from environment variables
Tricentis.Simulator.Agent.exe --variables apiKey=%API_KEY_FROM_VAULT%,dbPassword=%DB_SECRET%
```

Then use them in your simulation:

```yaml
services:
  - name: authenticated-service
    steps:
      - direction: Out
        message:
          headers:
            Authorization: "Bearer {VAR[apiKey]}"
          payload: '{"password": "{VAR[dbPassword]}"}'
```

### 3. Dynamic Content Generation

```yaml
services:
  - name: dynamic-response
    steps:
      - direction: Out
        insert:
          - value: "Welcome {VAR[User]} to {VAR[workspace]} environment!"
```

## Best Practices

1. **Use Configuration Files for Non-Sensitive Data**: Store common configuration in `appsettings.yml`
2. **Use Command Line for Secrets**: Pass sensitive information via command line arguments referencing environment variables
3. **Descriptive Variable Names**: Use clear, descriptive names for your variables
4. **Environment Separation**: Use variables to maintain separate configurations for different environments
5. **Documentation**: Document the required variables for each simulation

## Variable Precedence

When the same variable is defined in multiple places, the following precedence applies:
1. Command line arguments (highest priority)
2. appsettings.yml configuration (lowest priority)

## Example Simulation

See `variables.yml` in this directory for a complete example demonstrating variable usage in API simulations.
