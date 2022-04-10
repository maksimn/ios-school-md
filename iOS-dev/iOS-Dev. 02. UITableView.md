# iOS-Dev. 02.

# UITableView, его делегаты и протоколы. Кастомизация tableview.

Таблицы `UITableView` - это компонент, на основе которого построено большинство интерфейсов в iOS-приложениях. Другой компонент, чуть более новый и современный - это `UICollectionView`.

У `UITableView` нет нормального горизонтального скролла в отличие от `UICollectionView`. Он может быть сделан через хак в виде разворота слоев через `CALayer`. Через афинные трансформации поворачивался лэйер таблицы-вьюхи и скролл уже был горизонтальный. Сейчас это уже не нужно, так как есть `UICollectionView`.

Будем смотреть на интерфейс `UITableView`, что в нем вообще находится - data source, delegate, как сделать кастомные ячейки со своим дизайном, как сделать, чтобы они были разного размера. `UICollectionView` далее будет рассматриваться по такому же принципу.

```objectivec
@protocol UITableViewDataSource<NSObject>
```

Этот протокол представляет объект модели данных для `UITableView`. За внешний вид он НЕ отвечает (включая внешний вид ячеек). 

_Примечание:_ `<NSObject>` означает протокол, от которого отнаследовался протокол `UITableViewDataSource`.

---

Для `UITableView` есть перетаскивание ячеек "из коробки" - drag-and-drop.

Еще можно настроить высоту. По дефолту - `UITableViewAutomaticDimension`. При правильно заданных констрейнтах расчет высоты для таблицы будет работать в автоматическом режиме. Эта фишка появилась... а, с iOS 5. С автоматическим расчетом высоты были проблемы на iOS 9, различные баги, для нормальной работы надо было городить костыли.

Констрейнты негативно влияют на перформанс приложения. Расчеты, алгоритмы внутри нетривиальны. Легко может бы ниже 60 fps, особенно при скролле. Поэтому в мессенджерах не рекомендуют использовать констрейнты.

Оптимизация может быть через фреймы; другой способ - через упрощение иерархии view: например, Core Text вместо `UILabel`. В общем, есть более низкоуровневые библиотеки в iOS для оптимизации. 

Опасайтесь преждевременной оптимизации. Используйте профайлер.

## Секции таблицы. Размеры ячеек.

Таблица может формироваться не только ячейками, но и секциями, у каждой секции есть хедер, футер, estimated.

Для того, чтобы ускорить загрузку контента, можно использовать estimated - это такой предварительный расчет ячеек. Он распространяется не на конкретные ячейки, а на всю таблицу в целом. Если предварительно представляем, какой будет размер контента, то при задании этого свойства будет "мини-оптимизация" из коробки. 

То же самое - для расчета высоты элементов и секций. Тут же можно отступы сепараторов назначить. `separatorInset`, `separatorInsetReference`.

Можно сделать свой table view - наследник `UITableView`. В сбере есть свой такой table view с определенным "обвесом" - проапгрейженный table view. Есть баги с нулевой высотой хедеров/футеров.

Есть приколы с анимированным удалением, перемещением ячеек. Это отдельная область.

У table view ячеек есть метод `prepareForReuse()`, в котором мы должны сбрасывать контент. Потому что бывают артефакты когда мы скроллим быстро ячейки, если мы не реализуем этот метод, то в новых ячейках будет отображаться контент старых. Такие бывают лаги. Поэтому вся иерархия table view cell обнуляется в этом специальном методе.

С этим вариантом все понятно. А представьте, что у нас у каждой ячейки своя кастомная высота. Её каждый раз рассчитывать трудозатратно по ресурсам. Чтобы это было приемлемо по скорости работы, реализуется какое-то подобие кэша на уровне таблицы. У него список data sources, и может быть рядом список высот ячеек для каждого элемента. Можно сформировать и закэшировать уже рассчитанные высоты под каждую ячейку и просто в методах делегата подсовывать эту высоту рассчитанную. Это очередная оптимизация. Из коробки это не предоставляется -- нужно пилить отдельно.

Есть методы добавления, удаления, перезагрузки конкретных секций таблицы, конкретных ячеек. Возможное ДЗ - поиграть с таблицей, поэкспериментировать. 

## Данные для таблицы

Чтобы появился конкретный контент для таблицы, реализуем data source. (В данном случае - контроллер, реализующий протокол `UITableViewDataSource`). Опциональные методы количества секций в таблице, отдельные тайтлы под каждую секцию - заголовки секции. Заголовки для футеров секций. Может ли конкретная ячейка по индексу редактироваться - там появляются стандартные контролы при свайпе. Можно ли перемещать. И много чего ещё.

---

## Секции, хедеры и футеры.

Есть plain таблица - просто плоский список. Эту таблицу можно сгруппировать по секциям. Секция - есть хедер с тайтлом, у него набор ячеек и футер секции. Затем следующая секция с подобной структурой.

В чем профит? При скролле заголовок секции залипает вверху. Так работает механика table view. Он так залипает до скролла до следующей секции, а потом "уезжает" наверх из вида. И теперь на его месте залипает следующий заголовок секции. И т.д.

---

Нам нужны 2 метода -

1) метод количества ячеек (для секции?)

2) метод, возвращающий table view cell для данного индекса элемента в таблице. Ячейка должна быть заполнена контентом из data source. Здесь за счет того, что есть принцип переиспользования ячеек, можем попытаться достать ячейку из "кэша" таблицы, где есть ранее проинициализированные ячейки. Не надо создавать с нуля, мы можем получить их по определенным идентификаторам. Это делается так:

```objectivec
// во viewDidLoad:
[self.tableView registerClass:[AnimalTableViewCell class]
                              forCellReuseIdentifier:NSStringFromClass([AnimalTableViewCell class])];

// в методе UITableViewDataSource:
AnimalTableViewCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AnimalTableViewCell class]) 
	           forIndexPath:indexPath];
```

Регистрация классов ячеек для таблицы инициализирует типы ячеек и кэширует их на уровне своей реализации. Идентификатором выступает обычно сам класс, в принципе можно и захардкодить, но здесь сделано более гибко через `NSStringFromClass`.

Есть и хедер-футер по идентификатору. 

У `IndexPath` есть расширение в виде категории `UIKitAdditions`, которое имеет свойства

* `section`
* `row` 

Каждая ячейка в таблице размечается - `row` начинается с нуля, `indexPath.row` - это индекс ячейки в таблице. И есть такое же разбиение ячеек по секциям - ячейка характеризуется `row` и `section`.

У дефолтной ячейки `UITableViewCell` есть базовый text label, который можно задать. Есть сепараторы между ячеек.

У `UITableViewCell` есть свойство `contentView`, которое используется при создании ячеек своего типа:

```objectivec
// кода в типе, производном от UITableViewCell:

// init _coverImageView
[self.contentView addSubview:_coverImageView];
// ...
[self.contentView addSubview:_titleLabel];
// ...
[self.contentView addSubview:_subtitleLabel];
```

из коробки для cell есть стрелочки, кнопочки...

Есть дефолтные сепараторы внутри таблицы, и отдельно сепараторы внутри ячейки. 

Лэйбл в таблице наворочен, в том числе с точки зрения accessibility. User Interface Guidelines, для слабовидящих и незрячих; для арабского языка...

---

Обработка нажатия на ячейку таблицы - для этого нужна реализация `UITableViewDelegate`.

---

## Obj-C props and iVars

С iVar'ами работаем в только в следующих местах:

* инициализатор
* `dealloc`
* getters, setters

---

Если данные таблицы динамические -- приходят из сети, то есть методы `reloadData()` таблицы, которые перезагружают весь data source. После этого отображается весь контент.

Отображение части данных. Гладкий infinite scroll. Запрашиваем общее количество элементов данных...

Танцы с бубнами - на iOS 9 это делается одним образом, на iOS 10 - другим, на iOS 11 - третьим. И всё это надо свести в одно целое.

Минимальная версия СБОЛ - iOS 9.3. Месячная активная аудитория (МАУ) сейчас - 13 млн клиентов.

---

## Домашнее задание

1) добавить контент в кастомную ячейку (картинка, title и subtitle); от массива строк - к массиву Dictionary. Ключи - title, subtitle и др.

Картинки просто взять, добавить в бандл и сделать так, чтобы они отображались.

2) Сделать 2 типа разных ячеек. И чтобы четные ячейки были одного типа, нечетные -- другого.

То есть сделать второй тип наследника `UITableViewCell`. Сделайте его так -- чтобы картинка была справа, а не слева.

Верстать пока на фреймах. Констрейнты потом.

---

Есть вопрос того, как таблицы обновляют контент своих ячеек (секций, хедеров, футеров).

---

Код проекта с table view: https://github.com/maksimn/uitableview