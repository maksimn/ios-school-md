# Flutter. Списки.

Во флаттере есть разные способы работы со списками.

## Основные варианты списков

* `ListView`
* Виджет `Column` (который находится внутри `SingleChildScrollView`)
* `GridView` - списки типа "сетка из ячеек".
* `CustomScrollView` (slivers)

## ListView

Есть разные способы создания списков через `ListView`:

* Статический (для списка из небольшого количества элементов).
* Builder
* Separated
* Custom

### Статический ListView.

Статический скролящийся список из виджетов

```dart
children: List<Widget>
```

Для небольшого количества элементов, так как:

* создаются все элементы (не только видимые),
* все элементы занимают память.

Код примера статического `ListView`:

```dart
class _MyHomePageState extends State<MyHomePage> {

  // ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Item 1'),
            subtitle: Text('subtitle'),
            leading: Icon(Icons.radio_button_on),
            onTap: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Title'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            ),
          ),
          ListTile(
            title: Text('Item 2'),
            subtitle: Text('subtitle'),
          ),
          ListTile(
            title: Text('Item 3'),
            subtitle: Text('subtitle'),
            trailing: Icon(Icons.arrow_forward),
          ),
          ListTile(
            title: Text('Item 4'),
            leading: Icon(Icons.print),
          ),
          ListTile(
            title: Text('Item 5'),
            subtitle: Text('subtitle'),
          ),
          ListTile(
            title: Text('Item 6'),
            subtitle: Text('subtitle'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(/* ... */),
    );
  }
}
```

`ListTile` могут быть разными, это видно.

### ListView.builder

Это уже динамический список. Builder вызывается для тех элементов, которые появляются. При исчезновении уничтожаются. Называется _lazy construction_.

Полезные свойства:

* `itemBuilder` - задает функцию, которая принимает контекст и индекс, и возвращает элемент (`ListTile`).
* `itemCount` - необязательный (для `ListView.builder`). Главное – чтобы было всё хорошо с обращением к элементу массива по индексу.
* `scrollDirection` - вертикаль, горизонталь.
* `reverse`: `false | true` - порядок показа элементов.
* `addAutomaticKeepAlives` - чтобы список сохранялся при переключении между табами.

```dart
class _MyHomePageState extends State<MyHomePage> {
  // ...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item 1'),
            subtitle: Text('subtitle'),
            leading: Icon(Icons.radio_button_on),
            onTap: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Title'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            ),
          );
        },
        itemCount: 5,
      ),
      floatingActionButton: FloatingActionButton(/* ... */),
    );
  }
}
```

Пример с добавлением и удалением элементов:

```dart
class _MyHomePageState extends State<MyHomePage> {
  List<String> _items = <String>[];

  void _addItem(String item) {
    setState(() {
      _items.add(item);
    });
  }

  void _removeItem(String item) {
    setState(() {
      _items.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_items[index]), // здесь используется index
            subtitle: index % 2 == 0 ? Text('subtitle') : null,
            leading: Icon(Icons.radio_button_on),
            onTap: () => showDialog(
              context: context,
              builder: (_) => AlertDialog( // более сложный алерт-диалог.
                title: Text('Do you really want to remove this item?'),
                content: Text(_items[index]),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      _removeItem(_items[index]);
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            ),
          );
        },
        itemCount: _items.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addItem('Item ${_items.length}'),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
```

### 3. ListView.separated

То же, что и .builder, но добавляются разделители. У него есть `itemBuilder`, но дополнительно есть

`separatorBuilder` (похож на `itemBuilder`), в нём возвращается виджет, вокруг него также можно крутить логику.

Становится обязательным:

`itemCount`

```dart
class _MyHomePageState extends State<MyHomePage> {
  List<String> _items = <String>[];

  void _addItem(String item) {
    setState(() {
      _items.add(item);
    });
  }

  void _removeItem(String item) {
    setState(() {
      _items.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => ListTile(/*
          ...
        */),
        itemCount: _items.length,
        separatorBuilder: (context, index) => Divider(
          indent: 8, // отступ разделитя от начала
          color: Colors.grey,
        ),
      ),
      floatingActionButton: FloatingActionButton(/* ... */),
    );
  }
}

```

### 4. ListView.custom

Свой кастомный список. На практике встречается редко.

`SliverChildListDelegate` – статический

`SliverChildBuilderDelegate` – с builder’ом

Удобен, если хотим builder вынести в свой класс.

### Поля ListView:

`ScrollPhysics` - то как список будет себя вести при скролле

* `BouncingScrollPhysics` - эффекты при скролле (~ iOS).
* `ClampingScrollPhysics` ~ Android.

* `AlwaysScrollableScrollPhysics` - всегда скроллится.
* `NeverScrollableScrollPhysics` - список никогда не скроллится.

и другие (более специфичные, кастомные). 

`KeepAlive` - чтобы сохранялось состояние элементов, которые пропадают с экрана (например, при переключении табов запоминать offset).

В ListView:

`addAutomaticKeepAlives = true`

Но в свой класс нужно добавить, в своём State классе добавить `AutomaticKeepAliveClientMixin`

```dart
@override bool get wantKeepAlive => true;
```

## AnimatedList

ListView с анимацией.

Параметры:

`key` – чтобы затем обращаться к `AnimatedList` по этому ключу. Ключ, чтобы можно было достучаться до анимации. Он передаётся в AnimatedList и используется в методах в `itemBuilder`.

```dart
class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<String> _items = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: AnimatedList(
        key: _listKey,
        itemBuilder: (context, index, animation) =>
            _slideItem(context, animation, _items[index]),
        initialItemCount: _items.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addItem('Item ${_items.length}'),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _slideItem(BuildContext context, Animation animation, String item) {
    final index = _items.indexOf(item);
    return SlideTransition(
      position: animation.drive(Tween(
        begin: Offset(-1, 0),
        end: Offset(0, 0),
      )),
      child: ListTile(
        title: Text(item),
        subtitle: index % 2 == 0 ? Text('subtitle') : null,
        leading: Icon(Icons.radio_button_on),
        onTap: () => _promtRemoveItem(item),
      ),
    );
  }

  void _promtRemoveItem(String item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Do you really want to remove this item?'),
        content: Text(item),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              _removeItem(item);
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  void _addItem(String item) {
    _listKey.currentState?.insertItem(_items.length);
    setState(() {
      _items.add(item);
    });
  }

  void _removeItem(String item) {
    final index = _items.indexOf(item);
    _listKey.currentState?.removeItem(
        index, (context, animation) => _slideItem(context, animation, item));
    setState(() {
      _items.remove(item);
    });
  }
}
```

Здесь при добавлении элемент анимированно появляется и удалении анимированно улетает влево.

---

`ScrollNotification`

Оборачиваем наш `ListView` в `NotificationListener<ScrollNotification>`. Это виджет, в который можно обернуть свой компонент и получать оповещения.

В обработчике `onNotification` получаем события.

Это может быть нужно, например, для того, чтобы следить за скроллом списка, и когда он подходит к концу, по какой-то логике подгружать элементы с бэка. Или еще что-то менять на экране. 

__Пример кода:__

```dart
class _MyHomePageState extends State<MyHomePage> {
  List<String> _items = <String>[];
  void _addItem(String item) {
    setState(() {
      _items.add(item);
    });
  }

  void _removeItem(String item) {
    setState(() {
      _items.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: NotificationListener<ScrollNotification>(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_items[index]),
              subtitle: index % 2 == 0 ? Text('subtitle') : null,
              leading: Icon(Icons.radio_button_on),
              onTap: () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Do you really want to remove this item?'),
                  content: Text(_items[index]),
                  actions: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        _removeItem(_items[index]);
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ),
              ),
            );
          },
          itemCount: _items.length,
        ),
        onNotification: (scrollNotification) {
          print('[scrollNotification] ${scrollNotification.metrics.pixels}');
          return true;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addItem('Item ${_items.length}'),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
```

---

`ScrollController`

Допустим, нужно следить за положением оффсета и по текущему значению крутить какую-то кастомную логику, напр. менять размеры элементов, альфу элементов.


1. Создаём его
2. Добавляем listener
3. Передаём его в ListView
4. Вызвать dispose

Текущее значение offset можно получить из соответствующего поля контроллера.

