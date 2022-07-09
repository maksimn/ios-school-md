# iOS-Dev. 

# SwiftUI

__Особенности SwiftUI (в сравнении с UIKit).__

__Элементы в SwiftUI. Layout-контейнеры.__

__Свойства элемента. Модификаторы в SwiftUI.__

__Списки в SwiftUI.__

__Навигация в SwiftUI.__

__View в SwiftUI. Стейт-переменные. "Источник правды", что это такое.__

__Анимации в SwiftUI.__

__ObservableObject, @Published, @StateObject, @ObservedObject, @Binding.__

__Tooling в SwiftUI.__

* Декларативность.
* Наличие удобного инструментария.

Ещё из-коробки SwiftUI также предоставляет следующие возможности:

* Локализация
* Dark Mode
* Dynamic Type (автоматическое изменение размеров шрифта в зависимости от предпочтений пользователя)
* ...

В SwiftUI подходе нет отдельных файлов с разметкой view, всё представлено в swift-коде.

Канвас в Xcode показывает превью представления. Превью тоже пишется на Swift. Поэтому превью можно кастомизировать.

Элементы можно перетаскивать на канвас из библиотеки элементов. И всё будет синхронно отображаться на канвасе и в коде.

`VStack` - общий layout-контейнер в SwiftUI. Складывает элементы в вертикальный стек.

`HStack` - аналогично горизонтальный стек.

Это контейнеры, т.е. любой элемент можно поместить внутрь их.

`Text` - элемент для представления текста.

На элемент в коде можно нажать Command + click + Embed into HStack.

`Image` - элемент для представления изображения.

```swift
VStack(alignment: .leading) {
  ...
}
```

Так задается свойство `alignment` для элемента.

Инспектировать элемент на канвасе: Ctrl + Option + click.

```swift
Text("Some text")
  .font(.subheadline) // задать шрифт текста.
  .foregroundColor(.secondary)
```

Такие методы в SwiftUI называются "модификаторами" (modifiers). Это позволяет задать _вид_ и _поведение_ элементов интерфейса.

`List` - элемент для представления списка. У него нет делегата или data source, только представления элементов списка.

`Identifiable` - интерфейс для элемента списка данных, чтобы можно было работать с их появляением/уходом в SwiftUI. У него есть свойство `id` типа `UUID`.

Элементы списка получают нужный им размер ячеек автоматически.

Список модифаеров можно увидеть в Xcode library. Модификаторы можно перенести на канвас.

`NavigationView` - элемент для навигации в приложении. Имеет navigation bar и navigation stack.

```swift
NavigationView {
  // ... 
}.navigationTitle("Some title")
```

`NavigationLink` - элемент, который позволяет запушить некоторое представление на вершину стека навигации.

Превью имеет кнопку, позволяющую перейти в режим живого взаимодействия с экраном превью.

Для того, чтобы вынести вью из данного большого вью, нажимаем в Xcode Command + click над вью в коде -> Extract subview. То есть в SwiftUI очень удобно работать с разделением ответственности.

`ForEach(collection) { ... }` создает вью для каждого элемента в коллекции.

`Spacer()` - layout-элемент в SwiftUI.

Модификаторы `Image()`:

`resizable()`

`aspectRatio(contentMode: .fill)`

## Устройство SwiftUI

View в SwiftUI - это структура, поэтому она не наследует хранимых свойств.

View в SwiftUI - lightweight.

Протокол `View` требует только одно свойство: `body`.

Но вью определяет не только свой ui, но и _зависимости_.

Пользователь может совершать действия, напр. тапать и переключать представление из одно вида в другой:

```swift
struct SandwichDetail: View {
  let sandwich: Sandwich

  @State private var zoomed = false

  var body: some View {
    Image(...)
      ...
      .aspectRatio(contentMode: zoomed ? .fill : .fit)
      .onTapGesture { zoomed.toggle() }
  }
}
```

Для этого нужно завести state-переменную. Тогда будет выделен pesistent storage для хранения этой переменной от имени данного вью.

Одна из особенностей стейт-переменных состоит в том, что SwiftUI может наблюдать за тем, что они записываются и считываются. Раз оно считывается внутри `body`, то SwiftUI знает, что отображение вью зависит от него. Поэтому когда оно изменяется, `body` вызывается еще раз с новым значением состояния. И UI обновляется.

Traditional UI frameworks don't distinguish between __state variables__ and _plain old properties_. In SwiftUI, every possible state your UI might find itself in

* the offset of a scroll view, 
* the highlightness of a button, 
* the contents of a navigation stack -- 

is derived from an authoritative piece of data often called __"a source of truth."__ Collectively, __your state variables__ and __your model__ constitute __the source of truth__ for your entire __app__.

You can neatly classify every property as either 

* __a source of truth__
* or _a derived value_. 

The `zoomed` state variable is a source of truth. The `contentMode` property is derived from it.

Every state variable is a read-write source of truth. 

Every plain old property is a read-only derived value. 

```
Схема разных видов примитивов data flow:

             Source of Truth    Derived Value
           |                  |
Read-only  | Constant         | Property
           |                  |
Read-write | @State           | @Binding
           | ObservableObject |
```

SwiftUI invents a tool called `@Binding` for passing read-write derived values (примера не будет). And technically, any constant can serve as a perfectly good read-only source of truth. The test data driving our previews is an example of this.

Для того, чтобы SwiftUI отражал изменение данных модели, можно использовать объекты observable.

---

В SwiftUI имеют `body` такие абстракции как

* App
* View
* Scene

---

Добавление анимации перехода между двумя режимами просмотра: 

```swift
  // ...
  .onTapGesture {
    withAnimation {
      zoomed.toggle()
    }
  }
  // ...
```

---

В SwiftUI вьюхи вычисляют свой размер для того, чтобы размер соответствовал размеру их контента.

---

В SwiftUI в качестве превью можно сделать набор из нескольких экранов симуляторов для случаев разных данных.

---

Модификатор анимации перехода:

```swift
HStack {
    // ...
}
.transition(.move(edge: .bottom))
```

---

SwiftUI __data-driven__, не _event-driven_.

---

SwiftUI - multiplatform, позволяет работать не только с iPhone, но iPad и macOS. Код представлений един для всех платформ, специфичность делается легко.

--- 

Как сделать модель данных, в которых данные будет изменяемы, а не статичны?

```swift
// Это изменяемый объект, который содержит список сэндвичей.
// Протокол ObservableObject нужен для маркировки класса, изменениях данных которого 
// будут наблюдаемы другими объектами в SwiftUI.
class SandwichStore: ObservableObject {

  // Атрибут свойства показывает, за изменениями каких данных будут наблюдать другие объекты
  @Published 
  var sandwiches: [Sandwich]

  init(sandwiches: [Sandwich] = []) {
    self.sandwiches = sandwiches
  }
}

struct SandwichesApp: App {
  
  // Помечает "источник правды" для изменяемого объекта (о. с изменяемыми данными)
  // Он автоматически будет наблюдать за изменениями объекта, чтобы обновить UI, 
  // когда данные изменятся.
  @StateObject
  private var store = SandwichStore()

  var body: some Scene {
    WindowGroup {
      ContentView(store: store)
    }
  }
}

struct ContentView: View {
  
  // Сообщает SwiftUI, что изменения данного объекта должны отслеживаться, чтобы UI обновлялся.
  @ObservedObject
  var store: SandwichStore

  var body: some View {
    NavigationView {
      // ...
    }
  }
}
```

__Модификаторы__

```swift
ForEach(store.sandwiches) { 
  SandwichCell(sandwich: $0)
}
.onMove(perform: moveSandwiches)
.onDelete(perform: deleteSandwiches)
```

Для вызова кода при операциях перемещения и удаления (swipe-to-delete) элементов списка.

__Модификатор__

```swift
.toolbar {
  #if os(iOS)
    EditButton()
  #endif
}
```

позволяет добавить любые SwiftUI вью на место элементов тулбара.

`EditButton` - контрол, который автоматически переключает в edit mode на iOS.

---

В macOS swipe-to-delete может работать просто и сразу, но в iOS необходимо иметь кнопку Edit, которая переведет список в режим редактирования (_хмм... похоже на требования Human Interface Guidelines, возможно их действительно нужно знать_). В iOS в режиме редактирования это будет на swipe-to-delete, а tap-to-delete.

---

В превью есть кнопка Inspect, которая позволяет настроить превью, напр., задать пользовательское предпочтение размера шрифта (модификатор `environment()`).


