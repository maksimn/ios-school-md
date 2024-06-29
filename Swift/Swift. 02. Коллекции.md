# Swift. Коллекции

## Массивы

Массив в swift можно создать большим числом способов. 

Массив - это генерик-структура Array.

```swift
let arr1 = [1, 2, 4]
let arr2 = [Int]()
let arr3 = Array<Int>()
let arr4: [Int] = [1, 2]
```

Способ итерации по элементам массива, при котором можно работать с индексом:

```swift
for (index, element) in arr1.enumerated() {
	// ...
}
```

---

## Словари

Ключ словаря в Swift должен удовлетворять протоколу `AnyHashable`.

Удаление элемента из словаря - просто приравнивание `nil` по ключу.

---

## Протокол Sequence

`Sequence` предоставляет последовательный доступ к элементам коллекции с использованием итератора. Например, конструкция цикла `for in` языка Swift работает для `Sequence`.

https://developer.apple.com/documentation/swift/sequence

## Протокол Collection

Это протокол, означающий что коллекцию можно обойти неограниченное количество раз без её мутаций и получить доступ к её элементам через `Index` и `subscript()`.

## Метод map()

Реализация (почти настоящая):

```swift
extension Sequence {

    public func map<T>(_ transform: (Element) throws -> T) rethrows -> [T] {
        var result = [T]()

        for item in self {
            result.append(try transform(item))
        }

        return result
    }
}
```

Особенности - 1) map работает с throwable функциями преобразования.

2) Ключевое слово `rethrows` означает: "if the function that gets passed in throws, then map2() throws, but if the function that gets passed in doesn't throw then map2() doesn't throw either.

map можно использовать не только для коллекций, но и для optionals.

## Метод flatMap()

`flatMap()` - из вложенных массивов делает плоский (в частном случае массивов, а в общем случае он работает для Sequence).

```
func flatMap<SegmentOfResult>(
  _ transform: (Self.Element) throws -> SegmentOfResult
) rethrows -> [SegmentOfResult.Element] where SegmentOfResult : Sequence
```

Реализация:

```swift
extension Sequence {

    public func flatMap<SegmentOfResult>(
        _ transform: (Element) throws -> SegmentOfResult
    ) rethrows -> [SegmentOfResult.Element] where SegmentOfResult : Sequence {
        var result: [SegmentOfResult.Element] = []

        for item in self {
            let subItems = try transform(item)

            for subItem in subItems {
                result.append(subItem)
            }
        }

        return result
    }
}
```

## Метод compactMap()

`compactMap` - очищает массив от nil-значений. 

```swift
extension Sequence {

    public func compactMap<ElementOfResult>(
        _ transform: (Self.Element) throws -> ElementOfResult?
    ) rethrows -> [ElementOfResult] {
        var result: [ElementOfResult] = []

        for item in self {
            if let mappedItem = try transform(item) {
                result.append(mappedItem)
            }
        }

        return result
    }
}
```

---

reduce - для агрегации

```swift
let arr = [1, 2, 3]

let sum = arr.reduce(into: 0) { res, item in
    res += item
}
```

---

filter для фильтрации коллекций.

---

`Array`

```
func index(of element: Self.Element) -> Self.Index?
```

`Index` - A type that represents a position in the collection.

index(of: 3)

---

first условие

```
func firstIndex(where predicate: (Self.Element) throws -> Bool) rethrows -> Self.Index?
```

---

forEach

