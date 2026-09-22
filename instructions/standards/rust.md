## Dependencies and features

Keep dependency feature sets as small and explicit as practical.

Prefer:

```toml
syn = {
    version = "...",
    default-features = false,
    features = [...]
}
```

when the required feature set is understood.

Test-only capabilities should normally be enabled through dev-dependencies
rather than production dependencies.

Do not increase the runtime or compile-time dependency surface merely for
convenience in tests unless there is a clear benefit.
