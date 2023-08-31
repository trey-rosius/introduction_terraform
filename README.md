## Introduction

Terraform is an open-source infrastructure as code (IaC) tool that allows you to safely and predictably create, change, and improve infrastructure.

AWS AppSync now supports javascript resolvers. That's good news for developers who dreaded working with VTL templates.

With the new appsync graphql resource, you can declare everything needed for a GraphQL API with a single resource definition.

- A top level `appsync` module including properties such as api keys, authentication, schema, caching, logging and tracing custom domains.
- A `function` property to configure `code`, `runtime`, `datasource` and other pipeline properties.
- A `resolver` property to configure code, runtime, pipeline function execution order, and other resolver properties.
- A `datasource` property defining nested datasource details like AWS Lambda or Amazon DynamoDB.
