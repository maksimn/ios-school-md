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
* `itemCount` - необязательный. Главное – чтобы было всё хорошо с обращением к элементу массива по индексу.
* `scrollDirection`
* `reverse`: `false | true`
* `addAutomaticKeepAlives`

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
      floatingActionButton: FloatingActionButton(/* ... */),
    );
  }
}
```

