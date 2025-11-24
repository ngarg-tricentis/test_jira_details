# 📊 Dynamic Resource – API Simulation Example

This example demonstrates how to use dynamic resource lookup in API simulation, where responses are selected from a CSV table based on incoming request parameters. The simulation chooses the appropriate response by matching request properties against table data.

---

## 📁 Files

| File | Description |
|------|-------------|
| `dynamic_resource.yml` | The simulation definition that demonstrates dynamic resource lookup based on path and query parameters |
| `data.csv` | A CSV resource table containing different response scenarios based on parameter combinations |

---

## 📦 Simulated API Endpoint

### `GET /a/{id}/b`
- **Purpose:** Demonstrates dynamic response selection based on path parameters and query strings
- **Path Parameter:** `id` - captured from the URL path (e.g., `/a/1/b`)
- **Query Parameters:** 
  - `x` - optional query parameter
  - `y` - optional query parameter
- **Behavior:** 
  - Extracts the `id` from the path and `x`, `y` from query parameters
  - Looks up matching row in the `data.csv` resource table
  - Returns the corresponding JSON response from the table

#### Example Requests and Responses:

**Request 1:** `GET /a/1/b?x=2&y=3`
```json
{"x":2,"y":3}
```

**Request 2:** `GET /a/1/b?x=2`
```json
{"x":2}
```

**Request 3:** `GET /a/1/b`
```json
{"error":"no data found"}
```

---

## 📚 Resource Table: `data.csv`

The simulation uses a pipe-separated CSV file with the following structure:

| a | x | y | data |
|---|---|---|------|
| 1 | 2 | 3 | {"x":2,"y":3} |
| 1 | 2 |   | {"x":2} |
| 1 |   |   | {"error":"no data found"} |

### Table Columns:
- **a**: Path parameter value (matches the `{id}` from `/a/{id}/b`)
- **x**: Query parameter `x` value (empty if not provided)
- **y**: Query parameter `y` value (empty if not provided)  
- **data**: JSON response to return for this parameter combination

---

## 🔧 How It Works

### 1. Request Processing
The service captures incoming request data:
```yaml
buffer:
  - type: Path
    value: a/{XB[a]}/*     # Extracts 'a' parameter from path
  - type: Query
    key: x
    name: x               # Captures 'x' query parameter
  - type: Query  
    key: y
    name: y               # Captures 'y' query parameter
```

### 2. Dynamic Resource Lookup
The simulation performs a conditional lookup in the CSV table:
```yaml
resource:
  read:
    - ref: data
      name: result
      one: "a='{B[a]}' AND {try[x='{B[x]}'][x='']} AND {try[y='{B[y]}'][y='']}"
```

This query:
- Matches rows where `a` equals the captured path parameter
- Uses `{try[condition][fallback]}` syntax to handle optional query parameters
- Returns the first matching row's `data` column

### 3. Response Generation
The matched data is returned as the response:
```yaml
insert:
  - value: "{b[result.data]}"
```

---

## 💡 Key Features

- **Dynamic Parameter Extraction**: Captures both path and query parameters from incoming requests
- **Conditional Resource Lookup**: Uses advanced query syntax with `{try[]}` for optional parameters
- **Flexible Response Mapping**: Maps different parameter combinations to specific JSON responses
- **Fallback Handling**: Provides default responses when parameters are missing

---

## 🛠 How to Use

1. Start the API Simulator and load `dynamic_resource.yml`
2. The service will be available on port 17071
3. Test different parameter combinations:
   - `GET http://localhost:17071/a/1/b?x=2&y=3`
   - `GET http://localhost:17071/a/1/b?x=2`
   - `GET http://localhost:17071/a/1/b`
4. Observe how responses change based on the provided parameters

---

## 🎯 Use Cases

This pattern is particularly useful for:
- **API Mocking**: Simulating different response scenarios based on input parameters
- **Test Data Management**: Maintaining response variations in an easily editable CSV format
- **Conditional Logic**: Implementing complex parameter-based routing without hardcoding responses
- **Data-Driven Testing**: Supporting multiple test scenarios from a single resource file

---

🔒 This example demonstrates advanced resource lookup capabilities and can be extended to support more complex parameter matching and response scenarios.
