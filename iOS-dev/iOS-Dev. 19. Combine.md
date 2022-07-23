# iOS-Dev. Combine.

Фреймворк реактивного программирования, подобный RxSwift.

При создании iOS-приложения возникает много проблем асинхронности, связанных с

* Target / Action
* Работой с оповещениями `NotificationCenter`,
* Асихронностью запросов к сети (`NSURLSession`)
* KVO
* Колбэки

Это всё разные виды асинхронных интерфейсов, которые непросто использовать вместе в сложных задачах. Combine - это новый системный фреймворк Apple, предлагающий общий единообразный и декларативный подход к этим проблемам обработки объектов-значений, возникающий с течением времени в процессе работы приложения. 

## Фичи Combine

__Использует генерики__.

__Типизация__.

__Composition first__.

__Request driven__.

## Ключевые понятия

__Publishers__. Это "источники" событий. Каждый тип - разный вид источника.

Определяют, как производятся значения и ошибки.

Являются value-типами.

И позволяют зарегистрировать подписчиков.

```swift
protocol Publisher {

    associatedtype Output // Тип производимого значения
    associatedtype Failure : Error

    // Ключевая функция
    func subscribe<S>(_ subscriber: S) 
        where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input

}
```

Если `Publisher` не порождает ошибок, то ассоциированный тип ошибки - `Never`.

_Пример_ publisher'a для `NotificationCenter`:

```swift
extension NotificationCenter {
    struct Publisher: Combine.Publisher {
        typealias Output = Notification
        typealias Failure = Never

        init(center: NotificationCenter, name: Notification.Name, object: Any? = nil)
    }
}
```

Т.о., NotificationCenter адаптирован к фреймворку Combine.

__Subscribers__. Это подписчики для обработки событий.

Они получают значения и completion (если паблишер финитный).

Являются ссылочными типами. (Потому что подписчики обычно мутируют своё состояние при получении значения).

```swift
protocol Subscriber {

    associatedtype Input
    associatedtype Failure : Error

    /// Subscription - это то, как Subscriber управляет потоком данных 
    /// от Publisher'a к Subscriber'у.
    func receive(subscription: Subscription)

    /// Получить инпут
    func receive(_ input: Self.Input) -> Subscribers.Demand

    /// Получает completion если паблишер финитный
    func receive(completion: Subscribers.Completion<Self.Failure>)
}
```

Если `Subscriber` не принимает ошибок, то ассоциированный тип ошибки - `Never`.

_Пример_ Subscriber'a:

```swift
extension Subscribers {
    class Assign<Root, Input>: Subscriber, Cancellable {
        typealias Failure = Never
        init(object: Root, keyPath: ReferenceWritableKeyPath<Root, Input>)
    }
}
```

Assign is a class and it's initialized with an instance of a class, an instance of an object and a type safe key path into that object.

What it does is when it receives input, it writes it out to that property on that object. Because in Swift there's no way to handle an error when you're just writing a property value, we set the failure type of Assign to Never. 

Посмотрим на общую схему того, как это всё работает. В чём шаблон?

```
ОБЩАЯ СХЕМА:

Объект контроллера или что-то подобное удерживает Subscriber'a,
и он вызывает subscribe(), чтобы приаттачить Subscriber к Publisher'у.
 -----------
| Publisher |
 -----------
 |                     ------------
 |<-------- subscribe(| Subscriber |)
 |                     ------------
 |                         |
 | receive(subscription:)  | the Publisher will send a subscription to the Subscriber
 |------------------------>| which the Subscriber will use to make a request from the Publisher
 |                         | for a certain number of values or unlimited.
 | request(_ : Demand)     |
 |<------------------------| Subscriber requests N values
 |                         |
 | receive(_: Input)       |
 |------------------------>| the Publisher is free to send N values or less 
 | receive(_: Input)       | to the Subscriber.
 |------------------------>|
 |         .               |
 |         .               |
 |         .               |
 |  receive(completion:)   | if the Publisher is finite, then it will eventually send 
 |------------------------>| a Completion or an Error.
```

В общем: one subscription, zero or more values and a single Completion.

__Операторы__. 

__*Пример*__ использования Publisher'a и Subscriber'a:

```swift
// Model:
class Wizard {
    var grade: Int
}
let merlin = Wizard(grade: 5)

// Прослушиваются оповещения о присваивании оценок волшебнику, и обновляется его оценка
let graduationPublisher = 
    NotificationCenter.Publisher(center: .default, name: .graduated, object: merlin)

let gradeSubscriber = Subscribers.Assign(object: merlin, keyPath: \.grade)

// Это не скомпилится, т.к. не совпадают типы Publisher'a и Subscriber'a.
// Тип Notification не соответствует типу Int.
// Здесь появляется необходимость применить оператор.
// Для того, чтобы сконвертировать Notification в Int.
graduationPublisher.subscribe(gradeSubscriber)
```

Операторы являются Publisher'aми, покуда они удовлетворяют этому протоколу.

Они _декларативны_ и поэтому являются value-типами.

Операторы описывают поведение для изменения значений (сложения, удаления и т.д.).

Оператор подписывается к Publisher'y ("upstream").

Оператор отправляет результат Subscriber'y ("downstream").

__*Пример оператора*__: Map

```swift
extension Publishers {
  struct Map<Upstream: Publisher, Output>: Publisher {
    // Map не создает своих Failure, поэтому просто отражает Upstream.Failure
    typealias Failure = Upstream.Failure

    let upstream: Upstream // структура инициализируется upstream'ом
    let transform: (Upstream.Output) -> Output // то, как конвертится
      // output upstream'a в собственный output.
  }
}
```

Тогда показанный ещё выше пример приобретает следующий вид:

```swift
let graduationPublisher = 
    NotificationCenter.Publisher(center: .default, name: .graduated, object: merlin)

let gradeSubscriber = Subscribers.Assign(object: merlin, keyPath: \.grade)

let converter = Publishers.Map(upstream: graduationPublisher) { note in
    return note.userInfo?["NewGrade"] as? Int ?? 0
}

converter.subscribe(gradeSubscriber)
```

Это теперь работает, но синтаксис многословный. Есть более удобный синтаксис:

```swift
extension Publisher {
    func map<T>(_ transform: @escaping (Self.Output) -> T) -> Publishers.Map<Self, T> {
        return Publishers.Map(upstream: self, transform: transform)
    }
}
```

Для каждого оператора есть функция-расширение протокола Publisher. Особенность в том, что в качестве upstream просто используется `self`. __И это полностью меняет подход к асинхронному программированию в вашем приложении__.

С новым синтаксисом:

```swift
let cancellable = 
    NotificationCenter.default.publisher(for: .graduted, object: merlin)
        .map { note in
            return note.userInfo?["NewGrade"] as? Int ?? 0
        }
        .assign(to: \.grade, on: merlin)
```

Видим, что отмена автоматически встроена в Combine. Она позволяет разорвать цепочку Publisher-Subscriber на раннем этапе, если нужно.

Этот пример выражает самую суть того, как нужно использовать Combine - в виде цепочки инструкций:

Источник значений -> цепочка трансформирующих операторов --> подписчик.

Операторов много. Они образуют т.н. 

## Declarative Operator API. 

---

Еще Combine состоит из


* Subject. Некоторые объекты, участвующие в потоках

* Scheduler. Шедулер - это выбор того потока/набора потоков, на котором будет исполняться код источника и код подписчика.

* ObservableObject - полезный тип, позволяющий реализовать "ObservableObject"

* Cancellable - для того, чтобы собирать вещи, которые вам не нужны.

---

## Виды Publisher'ов

* `Custom` 
* `Future`
* `Just`
* `Deferred`
* `Empty` 
* `Fail`
* `Record`

