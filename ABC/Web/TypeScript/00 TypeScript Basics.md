# Фичи TypeScript

TS - это типизированное надмножество JS, комплирующееся в простой JS.

Предназначен для возможности работы 
* в любом браузере
* на любом хосте (node.js)
* на любой ОС

Это Open Source с хорошей поддержкой инструментов.

## Ключевые фичи TS

* Поддерживает стандартный JS код
* Статическая типизация
* Инкапсуляция кода в классах и модулях
* Поддержка конструкторов, свойств и функций
* Можно определять интерфейсы
* arrow-функции (лямбда-выражения)
* Intellisense, проверка синтаксиса

## Компилятор TS

`.ts ==> tsc file.ts ==> .js`

`Greeter.ts`

```ts
class Greeter {
    greeting: string;
    constructor(message: string) {
        this.greeting = message;
    }
    greet() {
        return "Hello, " + this.greeting;
    }
}
```

==>

```js
Greeter.js
var Greeter = (function () {
    function Greeter(message) {
        this.greeting = message;
    }
    Greeter.prototype.greet = function () {
        return "Hello, " + this.greeting;
    };
    return Greeter;
}());
```

--------------

В TS есть модули/пространства имен

--------------

## Выведение типа

```ts
var num = 2;
```

Переменная num имеет тип number (отличие от JS).

```ts
var num: number = 2; [рекомендуемый подход]
```

- аннотация типа переменной. Присваивание не обязательно.

```ts
var any1;
```

- переменная любого типа.

В TS базовый тип всех типов - тип any. Если аннотации типа нет, то выводится тип any.

```ts
var str1 = num1 + 'str';
```

- нет ошибки, сработает как в JS.

## Типизация параметра функции

```ts
function addNumbers(n1: number, n2: number) {
    // ...
}
```

Типизация функции (входные параметры и возвращаемое значение типизированы):

```ts
var init : (s: string, p: string, c: string) => void
    = function (a, b, c) {
    // ...
};
```

Статическая типизация в JS опциональна.

Безопасность типов проверяется на этапе компиляции.

### Объявления из окружения (ссылки на библиотеки)

```ts
declare var document;

document.title = "Hello";
```

`lib.d.ts` импортируется по умолчанию и содержит ссылки на DOM и JS.

```ts
/// <reference path="jquery.d.ts" />
// типы для jquery

declare var $;

$(...).text(...);

declare var ko: KnockoutStatic;
```

string[] - тип массива строк

В TS есть типы null, undefined. Они могут быть присвоены любой переменной.

---------------------

Двойное отрицание !! в Js возращает булево значение.

-------------------------------

## Объектные типы

Примерами таких типов являются функции, классы, модуль, интерфейс и литералы объектов.

Могут содержать 
* свойства (открытые/закрытые, требуемые/опциональные)
* сигнатуры вызовов - методы
* конструктные сигнатуры - конструкторы
* индексные сигнатуры

```ts
var p : Object = {...}

var f : Function;
f = function(...) {...};

var squareIt = function (rect: { h: number, w?: number; }) {

}
```

- задан вид объекта-входного параметра. Знак вопроса означает необязательность.

Есть стрелочные функции.

```ts
var f = (a: number, b: number) => a * b;
```

### Определение функции, соответствующей интерфейсу

```ts
interface SquareFunction {
    (x: number) => number;
}
var squareItBasic: SquareFunction = (n) => n * n;
```

Интерфейс объекта 

```ts
interface Rectangle {
    h: number, 
    w?: number;
}

var squareIt = (rect: Rectangle) => number;
```

## Классы

```ts
class SomeClass {
    [public/private] someField: string; // pub по умолчанию

    constructor(someField: string) {
        this.someField = someField;
    }

    someMethod() {
        ...
    }
  
    set someField(value: string) {
        this.someField = value;
    } // property
    get someField(): string {...}
}
```

Краткое объявление поля:

```ts
constructor(public someField : string) {}
```

## Преобразование типов

```ts
var table : HTMLTableElement = document.createElement('table');
```

- тип из lib.d.ts. Этот код ошибочен, т.к. справа тип HTMLElement, а не HTMLTableElement. Нужно преобразование:

```ts
var table : HTMLTableElement = <HTMLTableElement>document.createElement('table');
```

TS знает об этих типах благодаря Type Definition Files. Они нужны при работе с DOM и другими библиотеками.

См. Definitely Typed.


## Расширение типов

```ts
class B extends A { 
    constructor() {
        super();
    }
}
```

Производный класс ДОЛЖЕН вызвать конструктор базового.

```ts
addAccessories(...accessories: Accessory[]) {

}
```

-- rest-параметр метода. Позволяет передать несколько аргументов, разделенных запятыми.

## Интерфейсы

Это контракты кода, который должен реализовать другой объект. 
Например, нужен объект с функциями start() и stop().

```ts
interface IEngine {
    start(callback: (ss: boolean, et: string) => void) : void;
    stop(...) ...
}
```

member?: string - необязательный член интерфейса

```ts
class A implements IDoSth {
    ...
}
```

Расширение интерфейса

```ts
interface IZzz extends IXxx {
  ...
}
```

## Модули TS

```ts
module/namespace dataservice {
    ...
};
```

Есть дефолтный глобальный модуль.

Модули можно расширять.

Модуль может импортировать другие модули.

Модуль экспортирует фичи.


Если написать 

```ts
class A {...}
```

то он поместится в глобальный модуль, где находится куча всего.

```ts
namespace Shapes {
    export class Rectangle { ...}
}
```

тогда Rectangle будет доступен извне через Shapes.Rectangle. Иначе - нет.

При создании модуля генерируется Immediately-Invoked Function Expression из JS

```ts
(function () {

})()
```

Как убрать код из глобального пространства имен

```ts
namespace myprogram {
    function run() {
        ...
    }

    run();
}
```

Модуль может иметь в названии несколько точек

```ts
module App.Tools.Utils { ... }
```

Сокращение

```ts
import Utils = App.Tools.Utils;
```

Импортирование внутреннего модуля

```ts
/// <reference path="shapes.ts" />
```

## Импортирование внешних модулей и управление крупными приложениями

Внутренние модули
* подобны пространствам имен
* для группировки кода
* их не нужно импортировать

Внешние модули
* Отдельно загружаемые модули
* Экспортируемые сущности могут быть импортированы в другие модули

```ts
import viewmodels = require('./viewmodels');
```

Внешние модули позволяют не задумываться о последовательностях сценариев.

AMD = Async Module Definitions

Управляют зависимостями, загружают их асинхронно.

Модули загружаются последовательно на основе определенных в них зависимостей. require.

Должен быть задан флаг компилятора `tsc --module AMD`

```ts
install requirejs
```

=>

```ts
import ds = require('./dataservice');
```

При подключении скрипта с requirejs через атрибут data-main="path" задается путь к точке входа.

+ нужна конфигурация requirejs.
