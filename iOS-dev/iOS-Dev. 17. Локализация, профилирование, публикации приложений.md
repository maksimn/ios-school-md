# iOS-Dev. 17.

# Средства отладки и профилирования. 

# Локализация приложения. 

`NSLocalizedString`. Принимает ключ (строку для локализации), возвращает локализованную строку.

Статические файлы с расширением `.strings`, в которых находятся строки с локализацией под разные языки. Там хранятся строки в виде ключ-значение.

Бандл -- это тот контейнер, в котором лежат наши статические ресурсы. Через параметры может передаваться специфический бандл, если у Вас их несколько. Main bundle используется по дефолту.

* `.strings` для английских строк.
* `.strings` для русских строк.

Локализация сторибордов и ксибов -- это отдельная тема, там достаточно много рутинной работы. Есть различные инструменты, позволяющие это автоматизировать. Можно их посмотреть на гитхабе.

Отдельный сториборд дублируется для каждого языка. Там могут быть разные шрифты для разных языков.

Ничего сложного в теме локализации нет.

Есть системный язык айфона, который, например, установлен в русской локали. Тогда у нас автоматически подтягивается русская локализация. С помощью `NSLocalizedString` язык может измениться только через изменение системного языка в айфоне. Так просто в рантайме мы сменить язык не сможем без своих дополнительных приседаний.

# Подготовка к публикации в Store
