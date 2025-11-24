# Try Expression in API Simulations

This document demonstrates the `try` expression in Tricentis API simulations, which provides robust error handling by evaluating an expression and falling back to a default value if the expression fails.

## Overview

The `try` expression is a powerful error-handling mechanism that allows you to:
- **Gracefully handle expression failures** without breaking the simulation
- **Provide fallback values** when calculations or operations cannot be completed
- **Create resilient APIs** that continue functioning even when some data is missing or invalid
- **Implement defensive programming** patterns in your simulations

## What is the Try Expression?

The `try` expression evaluates a primary expression and, if that expression fails or throws an error, returns a specified fallback value instead. This prevents simulation failures and allows APIs to continue operating with reasonable defaults.

## Syntax

```yaml
value: "{try[primary_expression][fallback_value]}"
```

**Components:**
- `primary_expression`: The expression to attempt first (can be any valid simulation expression)
- `fallback_value`: The value to return if the primary expression fails

## How It Works

1. **Evaluation Attempt**: The simulator tries to evaluate the primary expression
2. **Success Path**: If successful, the result of the primary expression is returned
3. **Failure Path**: If the primary expression fails (throws an error, references missing data, etc.), the fallback value is returned instead
4. **Graceful Degradation**: The simulation continues without interruption

## Use Cases

### 1. Mathematical Operations with Missing Data

When performing calculations that might fail due to missing parameters:

```yaml
# Safe addition that handles missing parameters
value: "{try[{math[{b[a]} + {b[b]}]}][error: a and b are required]}"
```

**Behavior:**
- If both `a` and `b` buffers exist: Returns the sum (e.g., `3` when a=1, b=2)
- If either buffer is missing: Returns `"error: a and b are required"`

### 2. Buffer Access with Defaults

Accessing buffer values that might not exist:

```yaml
# Access user preference with default
value: "{try[{b[userTheme]}][light]}"
```

**Behavior:**
- If `userTheme` buffer exists: Returns the theme value
- If buffer doesn't exist: Returns `"light"` as default

### 3. Complex Expression Chains

Handling failures in nested expressions:

```yaml
# Complex calculation with fallback
value: "{try[{math[{b[price]} * {b[quantity]} * {b[taxRate]}]}][0.00]}"
```

**Behavior:**
- If all buffers exist: Returns calculated total
- If any buffer is missing: Returns `"0.00"`

### 4. API Response Resilience

Creating APIs that always return valid responses:

```yaml
# User profile with safe field access
payload: |
  {
    "name": "{try[{b[firstName]} {b[lastName]}][Anonymous User]}",
    "email": "{try[{b[userEmail]}][not-provided@example.com]}",
    "score": {try[{b[userScore]}][0]}
  }
```

## Example Simulation

The `try.yml` file demonstrates a practical use case:

### Service Definition

```yaml
services:
  - name: try service
    steps:
      - trigger:
          - type: Path
            value: try
        buffer:
          - type: Query
            name: a
            key: a
          - type: Query
            name: b
            key: b
      - direction: Out
        insert:
          - jsonPath: result
            dataType: Numeric
            value: "{try[{math[{b[a]} + {b[b]}]}][error: a and b are required]}"
```

### Test Scenarios

The simulation includes comprehensive tests:

1. **Success Case**: `GET /try?a=1&b=2`
   - Both parameters provided
   - Returns: `{"result": 3}`

2. **Failure Case**: `GET /try?a=1`
   - Missing parameter `b`
   - Returns: `{"result": "error: a and b are required"}`

## Advanced Patterns

### Nested Try Expressions

You can nest try expressions for multiple fallback levels:

```yaml
# Multiple fallback levels
value: "{try[{b[primaryValue]}][{try[{b[secondaryValue]}][default]}]}"
```

### Try with Different Expression Types

The try expression works with any simulation expression:

```yaml
# With date expressions
value: "{try[{date[{b[customFormat]}]}][{date}]}"

# With regex expressions  
value: "{try[{regex[{b[pattern]}]}][.*]}"

# With variable access
value: "{try[{VAR[dynamicConfig]}][static-default]}"
```

### Conditional Logic with Try

Combine try expressions with other logic:

```yaml
# Complex conditional with safe evaluation
value: "{try[{math[{b[score]} >= 80 ? 'Pass' : 'Fail']}][Not Evaluated]}"
```

## Benefits of Try Expressions

1. **Fault Tolerance**: Simulations continue running even when individual expressions fail
2. **Graceful Degradation**: APIs provide meaningful responses instead of errors
3. **Defensive Programming**: Protect against missing or invalid data
4. **User Experience**: End users receive consistent, predictable responses
5. **Debugging Aid**: Fallback values can provide diagnostic information

## Best Practices

1. **Meaningful Fallbacks**: Choose fallback values that make sense in your API context
2. **Consistent Error Messages**: Use standardized error messages for similar failure scenarios
3. **Document Behavior**: Clearly document what fallback values mean to API consumers
4. **Test Both Paths**: Always test both success and failure scenarios
5. **Avoid Silent Failures**: Use descriptive fallback values rather than empty strings
6. **Performance Consideration**: Remember that failed expressions still consume processing time

## Error Scenarios Handled

The try expression can handle various types of failures:

- **Missing Buffer Values**: Referenced buffers that don't exist
- **Invalid Mathematical Operations**: Division by zero, invalid number formats
- **Malformed Expressions**: Syntax errors in nested expressions
- **Type Mismatches**: Attempting operations on incompatible data types
- **Null/Empty Values**: Operations on null or empty data

## Running the Example

1. Deploy the `try.yml` simulation to a simulator agent
2. Test the success case:
   ```bash
   curl "http://localhost:port/try?a=5&b=3"
   # Returns: {"result": 8}
   ```
3. Test the failure case:
   ```bash
   curl "http://localhost:port/try?a=5"
   # Returns: {"result": "error: a and b are required"}
   ```

## Integration with Other Features

The try expression works seamlessly with other simulation features:

- **Buffers**: Safe access to buffer values with defaults
- **Variables**: Fallback when variables are not defined
- **Mathematical Expressions**: Error handling for calculations
- **Templates**: Reusable error-handling patterns
- **Verification**: Safe validation with default behaviors

## Comparison with Other Error Handling

| Approach | Behavior on Error | Use Case |
|----------|-------------------|----------|
| **try expression** | Returns fallback value | Graceful degradation |
| **verify step** | Stops execution | Strict validation |
| **conditional logic** | Branches execution | Complex decision trees |

The try expression is the preferred method for creating resilient APIs that maintain functionality even when individual operations fail, making it an essential tool for production-ready API simulations.
