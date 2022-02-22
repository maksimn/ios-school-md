# Flutter 4. Билдеры.

* Билдеры позволяют нам обернуть создание виджета в коллбек, который будет вызван в методе `build` непосредственно Builder’а. Билдер - это сам виджет.
* Билдеры также позволяют обновлять состояние виджета в зависимости от асинхронного получения результата какой-то работы, при этом не заботясь о написании сложной логики или `StatefulWidget`
* Бывают ситуации, когда нам нужен контекст не родителя, а конкретного виджета, который мы создаём в `build` своего виджета

__Виды билдеров и где их применять с пользой__

* `Builder` (это вид билдера, он так и называется) оборачивает виджет в коллбек, предоставляя возвращаемому виджету дочерний контекст (а не контекст parent’а)
* `FutureBuilder` обновляет состояние виджета в зависимости от результата `Future`
* `StreamBuilder` обновляет состояние виджета в зависимости от последнего значения в `Stream`
* `ValueListenableBuilder` обновляет состояние виджета в зависимости от подписки на `ValueListenable`
* `LayoutBuilder` позволяет получить constraints (родителя) при построении виджета

__Пример__ базового билдера:

```java
class MyBuilderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        // имеет один параметр:
        // Функция, прин. контекст и возвращает виджет:
        builder: (context) => Center( 
          child: GestureDetector(
            child: FlutterLogo(
              style: FlutterLogoStyle.stacked,
              size: 100,
            ),
            // Показывает bottom sheet при нажатии
            onTap: () => _showBottomSheet(context, 'Hello there!'),
          ),
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.message),
            // А здесь приложение падает.
            // Потому что здесь контекст не parent'a, а объекта, который находится
            // еще выше, чем Scaffold
            onPressed: () => _showBottomSheet(context, 'Hello there!'),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context, String title) {
    final widget = Container(
      height: 250,
      width: MediaQuery.of(context).size.width,
      color: Colors.lightBlue,
      child: Text(title),
    );
    // Scaffold это InheritedWidget
    Scaffold.of(context).showBottomSheet((context) => widget);
  }
}
```

Билдер нужен для того, чтобы работать в нужном контексте.

```java
class FutureBuilderSample extends StatefulWidget {
  @override
  _FutureBuilderSampleState createState() => _FutureBuilderSampleState();
}

class _FutureBuilderSampleState extends State<FutureBuilderSample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FutureBuilderSample'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          )
        ],
      ),
      body: FutureBuilder<String?>(
        // initialData: 'I am an initial data',
        future: Future<String?>.delayed(Duration(seconds: 3)).then((value) {
          // throw Exception('Casual error');
          return 'I am done, result: ${Random().nextInt(100)}';
        }),
        // FutureBuilder возвращает не только контекст, но и снэпшот.
        builder: (context, snapshot) {
          print('connectionState: ${snapshot.connectionState}');
          print('data:${snapshot.data}');

          // снэпшот имеет полезные свойства, показывающие состояние future.
          if (snapshot.connectionState == ConnectionState.none) {}

          if (snapshot.connectionState == ConnectionState.waiting) {}

          if (snapshot.connectionState == ConnectionState.active) {}

          if (snapshot.connectionState == ConnectionState.done) {}

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          final _data = snapshot.data;
          if (_data != null) {
            return Center(
              child: Text(
                _data,
                textAlign: TextAlign.center,
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
```

Т.о., у нас 3 секунды вычислялась future, и это время отрисовывался индикатор. Потом был показан результат.

Футурой может быть обращение к серверу.

Результатом может быть ошибка.

А еще можно задать initialData.

__Stream__ - последовательность асинхронно получаемых ивентов. Что-то типа `Observable` из Rx. В стрим можно закидывать ивенты и слушать, как эти ивенты приходят.

```java
class StreamBuilderSample extends StatefulWidget {
  @override
  _StreamBuilderSampleState createState() => _StreamBuilderSampleState();
}

class _StreamBuilderSampleState extends State<StreamBuilderSample> {
  final stream = Stream<String?>.periodic(Duration(seconds: 1), (count) {
    if (count == 0) {
      return null;
    }

    if (count % 5 == 0 && count % 3 == 0) {
      throw Exception('fizzbuzz');
    } else if (count % 3 == 0) {
      return 'fizz $count';
    } else if (count % 5 == 0) {
      return 'buzz $count';
    }
    return '$count';
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StreamBuilderSample'),
      ),
      body: StreamBuilder<String?>(
        stream: stream, // стрим может иметь initialData.
        builder: (context, snapshot) {
          final _data = snapshot.data;
          if (_data != null) {
            return Center(
              child: Text(_data),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
```

```java
class ValueListenableSample extends StatelessWidget {
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ValueListenableSample'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Radius'),
            ValueListenableBuilder<int>(
              valueListenable: _counter,
              // value - значение из ValueNotifier'a
              // child - это какой-то виджет, который передаётся для того, чтобы
              // что-то с ним сделать
              // child позволяет лениво его создать один раз, а потом переиспользовать
              // при каждом перевызове коллбэка builder. Чтобы не пересоздавать его заново.
              builder: (context, value, child) => Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('$value'),
                  ClipRRect(
                    borderRadius:
                        BorderRadius.all(Radius.circular(value.toDouble())),
                    child: child,
                  ),
                ],
              ),
              // это тот чайлд
              child: Container(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                        'https://bipbap.ru/wp-content/uploads/2019/07/59b21ebebd0470cb6d8b4570.jpg'),
                    Text(Random().nextInt(100).toString(),
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 56,
                        )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: _counter,
        builder: (BuildContext context, int value, Widget? child) =>
            FloatingActionButton(
          child: Text('$value'),
          onPressed: () => _counter.value += 1,
        ),
      ),
    );
  }
}
```

ValueListenable билдер позволяет сделать простенькое состояние, когда есть ValueNotifier, который может находиться хоть в InheritedWidget'e, хоть в другом виджете, вы подписываетесь на него, слушаете его внизу по дереву, оптимизируете обновление данных - так работаете с потоком данных. 

```java
class LayoutBuilderSample extends StatefulWidget {
  @override
  _LayoutBuilderSampleState createState() => _LayoutBuilderSampleState();
}

class _LayoutBuilderSampleState extends State<LayoutBuilderSample> {
  bool isHorizontal = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LayoutBuilder"),
        actions: [
          IconButton(
              icon: Icon(Icons.crop_rotate),
              onPressed: () => setState(() => isHorizontal = !isHorizontal)),
        ],
      ),
      body: Center(
        child: Container(
          width: isHorizontal ? 400 : 200,
          height: isHorizontal ? 200 : 400,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 3,
            ),
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth > 300) {
                return _buildWideContainers();
              } else {
                return _buildNormalContainer();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNormalContainer() {
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.red,
      ),
    );
  }

  Widget _buildWideContainers() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            height: 100.0,
            width: 100.0,
            color: Colors.red,
          ),
          Container(
            height: 100.0,
            width: 100.0,
            color: Colors.yellow,
          ),
        ],
      ),
    );
  }
}
```

Позволяет получить констрейнты парента и что-то с ними делать. Можно, например, адаптировать верстку в зависимости от размеров пэрента. Адаптировать детей под меняющиеся размеры родителей. Работать без хаков типа использования `RenderObject`.
