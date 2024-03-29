# iOS-Dev. 10.

# Работа с сетью, NSURLSession, NSURLRequest

При работе с сетью эта сеть не является ресурсом, к которому нужен последовательный доступ, к ней можно обращаться параллельно из разных потоков, поэтому в терминах GCD это будет `.concurrent` queue.

`URLSession.delegateQueue` - можно сконфигурировать очередь, на которой выполняется completion при сетевом запросе (и методы делегата).

## Важный вопрос о проектирования операций с сетевым слоем.

_Пусть нам надо создать тудушку, тогда мы обращаемся в сеть к бекенду, чтобы создать ее на бэке, потом приходит ответ и мы сохраняем ее на устройстве. В этом подходе пользователю приходится долго ждать, пока создастся тудушка. Как с этим правильнее работать?_

Есть 2 основные концепции, как строить интерфейс с длительными операциями (хождения в бэкенд).

__1. Opportunistic UI__ - сначала сохраняем локально, а потом если поход в сеть не удался, то мы возвращаем пользователя в то состояние, которое было до того, как мы это применили. Так обычно работают лайки.

__2. Ввести 3-е состояние в UI__ - состояние "в процессе" ("думаю"). Нажимаем кнопку, появляется состояние "думаю", по завершению при успехе показывам юзеру, что всё окей. Иначе показываем ошибку и возвращаем в то, как было.

# ДЗ

Для доработки ДЗ по загрузке изображений можно использовать текущий проект (по пуш-уведомлениям). Нужно для локальных пушей осуществлять переход на экран поиска с заданными параметрами. Trigger - интервал или дата, минимум два разных контент-тайпа

+ CIFilter c лекции по работе с изображениями. Флоу такой: нашли картинки по поисковой строке, выбрали, отредактировали, закрыли приложение, через какое-то время пришел пуш, например: "Вы давно не искали собачек", в поисковой строке показывается 'собачка' и ищется исходя из контента пуша

