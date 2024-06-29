# Swift. Property Wrappers.

Механизм, позволяющий добавить дополнительное поведение к свойствам и сделать это переиспользуемым образом. То есть поведение, которое мы бы реализовывали в отдельных структурах, классах, мы можем инкапсулировать в отдельную сущность. 

Появились в 5.1.

__Пример__. Property Wrapper, который содержит логику чтения и записи свойства в UserDefaults.

```swift
@propertyWrapper // аннотация Property Wrapper
struct UserDefault<T> {
  let key: String
  let defaultValue: T

  var wrappedValue: T { // необходимое свойство для Property Wrapper
    get { return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
    set { UserDefaults.standard.set(newValue, forKey: key) }
  }

  var projectedValue: Self { // Обращение к объекту PW извне нельзя, заводят projected value
    self // изнутри обращение к полю возможно через нижнее подчеркивание.
  }

  func reset() {
    UserDefaults.standard.removeObject(forKey: key)
  }
}

enum Settings {
  @UserDefault(key: "SOME_SETTING", defaultValue: 1)
  static var someSetting: Int
}

Settings.$someSetting = 5

// Обращение к projected value
Settings.$someSetting.reset()
```

Еще пример Property Wrapper'а – `Lazy` для ленивой инициализации свойства значением.

# Swift. Result Builders.

Тип, добавляющий __синтаксис для создания вложенных структур данных в декларативном виде__.

Разрабатывались как способ реализации DSL. Примером DSL является код графического интерфейса на SwiftUI, который отличается от обычного свифта, который был привычен ранее.

RB Применимы к функциям, методам, геттерам и кложурам. 

RB оборачивают выражения в неявные вызовы методов для использования результатов их выполнения.

RB работают в compile-time.

Появились в 5.4.

```swift
// Result Builder
@resultBuilder enum ViewBuilder {
  static func buildBlock(...) -> some View { ... } 
}
```

Поэтому, например, для VStack

```swift
struct VStack<Content: View>: View {
  ...
  init(@ViewBuilder content: () -> Content {
    self.content = content()
  }
}
```

Имея лаконичный код разметки UI:

```swift
VStack {
  Text("Title").font(.title)
  Text("Content")
}
```

в действительности он разворачивается в вызовы

```swift
VStack.init(content: {
  let v0 = Text("Title").font(.title)
  let v1 = Text("Content")

  return ViewBuilder.buildBlock(v0, v1)
}
```

То есть DSL устраняет бойлерплейт.

Соответственно, Swift позволяет создавать собственные Result Builder'ы.
