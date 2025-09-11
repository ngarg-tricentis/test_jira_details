# Tricentis Simulation Examples

This repository contains practical examples for using Tricentis Simulation, a key capability of [Tricentis Tosca](https://www.tricentis.com/products/automate-continuous-testing-tosca/api-simulation/) designed to support API simulation and service virtualization. These examples demonstrate how to simulate APIs and virtual services to enable reliable and continuous testing, even when dependent systems are not available.

## What is Tricentis Simulation

Tricentis Simulation allows testers and developers to simulate the behavior of APIs, services, and components that are not yet implemented, are unstable, or are otherwise unavailable. By virtualizing these dependencies, you can

- Continue development and testing without waiting for other teams or systems.
- Avoid delays due to test environment unavailability.
- Simulate edge cases and negative scenarios that are difficult to reproduce in real systems.
- Enable parallel work across teams in complex microservice architectures.

Simulation is essential in shift-left testing and continuous testing strategies, helping teams catch issues early and increase release velocity.

## Schema Validation and Editor Support

This repository includes a `schema.json` file that contains the JSON schema for Tricentis Simulation YAML files. A schema is a formal specification that defines the structure, properties, and validation rules for simulation files.

### What is a Schema?

A schema serves as a blueprint that defines:
- The required and optional properties for simulation files
- The data types and formats for each property
- The valid values and constraints for configuration options
- The hierarchical structure of simulation components

### Schema Compliance

**All simulation YAML files must adhere to the schema defined in `schema.json`.** This ensures:
- Consistent file structure across all simulations
- Validation of configuration properties before deployment
- Prevention of runtime errors due to malformed configurations
- Compatibility with Tricentis Simulation tools and engines

### Editor Integration

The schema can be used in modern code editors and IDEs to provide:
- **Auto-completion**: Intelligent suggestions for properties and values as you type
- **Context help**: Inline documentation and descriptions for each property
- **Real-time validation**: Immediate feedback on syntax errors or invalid configurations
- **IntelliSense**: Enhanced editing experience with property hints and structure guidance

To enable schema support in your editor, configure it to associate YAML files with the `schema.json` file. Most editors like VS Code, IntelliJ IDEA, and others support JSON schema validation out of the box.

## What's in this Repository

This repository includes hands-on examples that illustrate how to use Tricentis Simulation in real-world scenarios. Each example is designed to be self-contained and comes with detailed explanations to help you understand the concepts and tools involved.

### 📁 Examples Overview

 Folder  Description 
---------------------
 `examples/shoppingCart`  Simulates a shopping cart service. 
 `examples/carServiceDemo`  Simulates a car service. 
 `examples/dataDriven`  Simulates a service based on data provided in a CSV file.

Each folder contains
- Simulation configuration files.

## Getting Started

Refer to [Tricentis Documentation](https://documentation.tricentis.com/tricentis_cloud/en/content/topics/sim_get_started.htm) for installation and configuration details.

### Example Usage

Each example includes a `README.md` inside its folder with
- What it simulates
- How to deploy it
- How to integrate with Tosca test cases
- Expected outputs and test scenarios

## Contribution

Contributions are welcome! Feel free to open issues or submit pull requests if you
- Have additional simulation use cases
- Found bugs in the examples
- Want to improve the documentation

---

Tricentis Simulation helps you break the testing bottlenecks caused by unavailable or unreliable systems. Use these examples to learn, prototype, and integrate simulations into your test strategy.

Happy Testing! 🚀
