# Swift.

При разработке (сервисов и т.п.) удобно вкладывать одну ошибку в другую, чтобы можно было легче понять, какая ошибка привела к возникновению ошибки на бизнес-слое:

```swift
enum TodoServiceErrors: Error {
    case fileSaveFailed(cause: Error)
    case fileLoadFailed(cause: Error)
    case networkError(cause: Error)
    case cacheError(cause: Error)
    case acquisitionFailed
}
```

