# Swift.

В Свифт есть 4 способа обработки ошибок

1 Обработка с использование блока do-catch
2 Распространение через throwing функции
3 Преобразование ошибок в optional значение
4 Остановка распространения ошибки через оператор try!

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

