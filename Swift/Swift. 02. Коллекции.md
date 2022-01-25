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

## Функции стандартной библиотеки

`map`

```swift
let arr = [1, 2, 3]
let res = arr.map { $0 + 1 }
```

map можно использовать не только для коллекций, но и для optionals.

flatMap - из вложенных массивов делает плоский.

compactMap - очищает массив от nil-значений.

reduce - для агрегации

```swift
let arr = [1, 2, 3]

let sum = arr.reduce(into: 0) { res, item in
	res += item
}
```

filter для фильтрации коллекций.

index(of: 3)

first условие

forEach

