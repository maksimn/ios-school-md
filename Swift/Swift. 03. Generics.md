# Swift. Generics

Нужны, чтобы не было дублированного кода, отличающегося только используемыми типами. Так как чем меньше кода, тем лучше. 

Генерики - это один из самых мощных языковых механизмов вообще. Его почти нет в Obj-C (кроме "жалких обрезков" от идеи дженериков). 

На дженериках построены коллекции Swift (см. занятие по коллекциям).

[что такое `inout` параметр функции Swift - это параметр, передаваемый по ссылке. Обобщенный параметр тоже может быть `inout`]

__Дженерик-функция__ - это универсальная функция для всех типов; в ней указан _placeholder_ для типа.

## Пример дженерик-типа - стек.

((Важный вопрос при реализации коллекции [стека]: должны ли элементы, которые в него добавляются и с которыми он работает, копироваться или сохраняться теми же самыми? То есть должна ли создаваться их копия или просто передаваться ссылка на них.

Это зависит от вашего выбора. Для стека, пожалуй лучше будет работать с копиями элементов - если это структура, и работать с ссылками, если это reference type.))

iOS Navigation Controller работает на основе стека.

Стек на основе структуры, чтобы было копирование значений. mutating создает новый стек каждый раз. Структура - неизменяемый тип данных.

У Apple все базовые коллекции - тоже структуры.

От целочисленного стека можно легко перейти к универсальному.

К дженерикам точно так же можно писать расширения, как и к другим типам, классам, перечислениям.

Расширим стек свойством `topItem` (аналог `peek`).

## Ограничения типа

Можно ограничивать типы, которые дженерик может принимать при создании экземпляра своего типа. Эти ограничения полезны во многих случаях.

Ограничения - от какого типа должен наследоваться передаваемый тип, или какой протокол он должен реализовывать (или набор протоколов).

Например, в стандартной структуре `Dictionary` тип ключа должен быть хэшируемым (`Hashable`). То есть можно использовать только `Hashable` типы ключей и при попытке использовать другие будет ошибка компиляции. Это отличие от Objective-C, где в подобном случае программа свалится только в run time.

---

## Associated Types ("Связанные типы")

Что такое __associated types__?

Это некоторый обобщенный тип, связанный с протоколом. Он задается в конкретном виде в тот момент, когда кто-то (класс или структура) имплементирует этот протокол.

Связанные типы указываются с помощью ключевого слова `associatedtype`.

Swift может самый вывести `typealias` для `associatedtype` из типа параметров соответствующих методов протокола. `typealias Item = Int` - необязательная строка.

---

Связанный тип может иметь ограничение [Слайд 29].

---

where-выражение может быть у расширений.

---

Совсем магия:

where-выражение может быть у связанных типов

---

## Type erasure (Стирание типов в Swift)

Type erasure удаляет из программы информацию о типе. 

Swift позволяет писать код в стиле протокольно-ориентированного программирования. 

Однако, программируя в таком стиле на Swift можно встретить ошибку компилятора

```
error: protocol 'MyAwesomeProtocol' can only be used as a generic constraint because it has Self or 
associated type requirements
```

В этой ошибке упомянуты

* ограничения обобщенного типа
* associatedtype'ы протоколов

This error is caused by attempting to use a protocol, with an associated type, as an argument to a function or as a collection of objects. 

Type erasure - это паттерн в Swift.

---

__Opaque типы__: https://docs.swift.org/swift-book/documentation/the-swift-programming-language/opaquetypes/

Это тип, позволяющий использовать возможности объекта без знания его конкретного типа.

От протоколов отличаются тем, что

* могут работать с associated type
* требуют, чтобы при этом использовался один и тот же тип (например, в функции, возвращающей `some SomeType` всегда возвращается объект одного и того же конкретного типа).

__Extending static member lookup in generic contexts__: https://www.hackingwithswift.com/articles/233/whats-new-in-swift-5-5

__Ключевое слово any для сущностных типов__ (_Introduce existential any_): https://www.hackingwithswift.com/articles/247/whats-new-in-swift-5-6

_Сущностный тип_ – новый тип данных, который позволяет хранить значение любого типа, согласного с заданным протоколом.

__Выведение типа из выражений по умолчанию__ (_Type inference from default expressions_): https://www.hackingwithswift.com/articles/249/whats-new-in-swift-5-7

Небольшая нишевая фича. Теперь для обобщенного типа или функции можно задать значение конкретного типа по умолчанию.

__Opaque объявления параметров__ (_opaque parameter declarations_): https://www.hackingwithswift.com/articles/249/whats-new-in-swift-5-7

Можно использовать `some` в объявления параметров:

```swift
func doSomething(array: [some Comparable]) {
    // ...
}
```

__Результаты в виде структурных opaque-типов__ (_Structural opaque result types_)

Теперь можно сделать возвращаемое значение с opaque-типом в виде 

* кортежа, 
* массива,
* замыкания, которое само возвращает opaque-тип.

__Разрешение сущностного использования для всех протоколов__ (_Unlock existentials for all protocols_): https://www.hackingwithswift.com/articles/249/whats-new-in-swift-5-7

Существенно смягчено использование протоколов как типов когда они имеют требования для Self или associated type. То есть становится допустимым код

```swift
let someName: any Equatable = "John"
let otherName: any Equatable = "Jane"
```

__Легковесные требования того-же-типа для первичных associated-типов__ (_Lightweight same-type requirements for primary associated types_): https://www.hackingwithswift.com/articles/249/whats-new-in-swift-5-7

__Ограничения для сущностных типов__ (_Constrained existential types_): https://www.hackingwithswift.com/articles/249/whats-new-in-swift-5-7

Теперь можно писать кода вроде ```any Sequence<Int>```.

__buildPartialBlock for result builders__: https://www.hackingwithswift.com/articles/249/whats-new-in-swift-5-7

__Неявно раскрываемые сущностные типы__ (_Implicitly opened existentials_): https://www.hackingwithswift.com/articles/249/whats-new-in-swift-5-7

__Пакеты значений и параметров типа__ (_Value and type parameter packs_): https://www.hackingwithswift.com/articles/258/whats-new-in-swift-5-9

Решают проблему большого количества параметров типа (раньше было ограничение на 10).


