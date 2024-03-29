# Server-driven UI (на примере DivKit)

Что это такое и когда его стоит использовать?

Потребность в SDUI возникла в Яндексе из следующего кейса - надо было делать релизы, в которых по-сути всего лишь вводился новый вид ячейки ("карточки") коллекции (новый `UITableViewCell` / `UICollectionViewCell`). Эту ячейку надо было закодить, а потом потратить 1-7 дней на ревью в App Store. Был даже критический случай, когда едва успели к Чемпионату мира по хоккею.

То есть этот подход по сути предназначен для отображения списков с данными, полученными с сервера - и без затрат на ревью в App Store (__сокращение Time to market__). Элементы предназначены по сути только для отображения, способов взаимодействия с ними небогато.

## Пример UI на DivKit.

Код экрана содержит вёрстку + данные и имеет формат json.

Он состоит из двух частей -

1) `templates` - по сути (кастомные) шаблоны UI-элементов, предназначенные для переиспользования кода.

Например,

* шаблон `tutorialCard` для отображения карточки, 
* шаблон `link` для отображения ссылки.

2) `card` - содержит данные для заданных шаблонов.

Элементы объединяются в список или другую структуры через контейнеры `container`.

```json
"div": {
    "type": "container",
    "items": [
        {}, {}, {}
    ]
}
```

Есть

Вертикальный, горизонтальный, overlap-контейнер.

Слайдеры, галереи, табы и пр.

Действия над элементами кодируются тоже в json'e через url'ы

Обработчик действия может выйти наружу в бизнес-логику iOS клиента за пределы слоя DivKit'а.

UI iOS клиента - нативный.

Навигации между экранами в DivKit нет, ее нужно делать самому "руками".

DivKit покрывает только некоторые случая простой вёрстки относительно простых экранов; для сложных экранов со сложной логикой он неприменим.

Результатом дивкита является по сути вьюшка, которую можно куда-то интегрировать. Это может быть маленькая вью, может быть целый экран или большая часть экрана, которая куда-то встраивается.

Возможна реализация форм с каким-то текстовым инпутом.

Когда меняется локаль на телефоне, приложение перезапускается.

ДивКит по сути: 

Вход - JSON данные
Выход - view, построенная на основе этого JSON.

Фид без тормозов - давняя задача в iOS, которую надо решать "своими руками". SwiftUI тут тоже не в помощь.

Еще на SDUI хорошо верстать экраны, состоящие только из текста и картинок. В общем, в случае простого UI.
