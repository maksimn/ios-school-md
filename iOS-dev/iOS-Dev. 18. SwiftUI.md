# iOS-Dev. 

# SwiftUI

* Декларативность.
* Наличие удобного инструментария.

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

Такие методы в SwiftUI называются "модификаторами" (modifiers). Это позволяют задать _вид_ и _поведение_ элементов интерфейса.

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

