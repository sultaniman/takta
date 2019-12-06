# Takta API

## Business logic stacks

Current architecture follows the separation of business logic into services
and vertical slicing for each context to keep controllers clean and concise.

```
router -> controller :action -> context service -> context
```
