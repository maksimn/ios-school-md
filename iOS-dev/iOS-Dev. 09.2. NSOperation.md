# iOS-Dev. 09. NSOperation.

`BlockOperation` позволяет некоторое замыкание обернуть в объект операции и работать способом, похожим на GCD.

`Operation` - это класс. Операция имеет жизненный цикл.

```swift 
class MyOperation: Operation {
  override func main() {
    // Здесь желательно проверять значение self.isCancelled.
  }
}
```

Операция заканчивается, тогда она переходит в состояние `finished`. После этого разблокируются другие операции, зависящие от нее.

Можно задавать зависимости одних операций от других операций.

Отмена: ```op.cancel()```

__OperationQueue__ похоже на Dispatch Queue, но имеет дополнительные свойства.

```
queue.maxConcurrentOperationCount = 4 // можно задать максимальный уровень параллелизма.

```

---

### Как из одной операции передать результат в другую?

2 основных подхода: 1) объявление в операции свойства типа `Result<T, E>`, вызов в методе `main()` success или failure. Потом код в точке вызова делает перекладывание результата.

2) использование зависимостей и `BlockOperation` для адаптерных операций. Это операция, которую добавляют между двумя операциями, а зависимость в виде `BlockOperation` просто переложит результат операции из одной в другую.

```swift
let someOp = MyOperation()
let adapter = BlockOperation { [someOp] in
  // ...
}

adapter.addDependency(someOp)
opQueue.addOperation(someOp)
opQueue.addOperation(adapter)
```

`let blockOp = BlockOperation { [op, op2] in ... }` - перекладывает результат из op в op2.

---

Создали просто `NSOperation` и вызвали `start`. Метод будет выполняться в главном потоке.

Если используем `NSOperationQueue`, то вызов операции будет по умолчанию уже в фоновом потоке.

---

В СБОЛе используются надстройки над `NSOperation` - называются chain'ы, это загрузчики данных по сети, но их можно использовать для чего угодно.

---

`blockCompletionOperation` выполнится только после окончания `blockOperation`. Как это сделать? Через явное указание зависимости:

```
NSOperationQueue *operationQueue = [NSOperationQueue new];
NSBlockOperation *blockCompletionOperation = [NSBlockOperation blockOperationWithBlock:^{  
  NSLog(@"The block operation ended, Do something such as show a successmessage etc");
  // This the completion block operation}];
NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{  
  //This is the worker block operation
  [self methodOne];
}];
[blockCompletionOperation addDependency:blockOperation];
[operationQueue addOperation:blockCompletionOperation];
[operationQueue addOperation:blockOperation];
```

__Пример:__ часы на `NSInvocationOperation`. Бесконечный цикл в бэкграунд-потоке, обновление view в главном потоке через `performSelectorOnMainThread`.

---

```swift
class AsyncOperation : Operation {

    private var _isExecuting = false
    private var _isFinished = false

    override func start() {
        guard !isCancelled else {
            finish()
            return
        }

        willChangeValue(forKey: "isExecuting")
        _isExecuting = true
        main()
        didChangeValue(forKey: "isExecuting")
    }

    override func main() {
        // NOTE: should be overriden
        finish()
    }

    func finish() {
        willChangeValue(forKey: "isFinished")
        _isFinished = true
        didChangeValue(forKey: "isFinished")
    }

    override var isAsynchronous: Bool {
        return true
    }

    override var isExecuting: Bool {
        return _isExecuting
    }

    override var isFinished: Bool {
        return _isFinished
    }
}

class MyAsyncOperation: AsyncOperation {
    override func main() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            // do the work
            print("Hello3")
            self.finish()
        }
    }
}
```