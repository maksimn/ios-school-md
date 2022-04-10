Полиморфный this-тип

Это тип, являющийся подтипом содержащего его класса или интерфейса.

То есть тип, на который ссылается this, возможно, является типом производного класса.

class Vehicle {
  drive() {
    return this;
  }
}

class Car extends Vehicle {
}

var v = new Vehicle();
v.drive(); // returns Vehicle type

var c = new Car();
c.drive(); // returns Car type

==================
﻿Слияние объявлений

Компилятор производит слияние двух отдельных объявлений, объявленных с одним и тем же именем, в единственное определение.

Пусть есть 2 интерфейса в разных частях приложения

interface Employee {
    name: string;
    doWork(): () => void;
}

interface Employee {
    title: string;
    phone: string;
}

Компилятор объединит их в единственный интерфейс

interface Employee {
    name: string;
    doWork(): () => void;
    title: string;
    phone: string;
}

Допускаются слияния
- интерфейсов
- перечислений
- пространств имен
- пространств имен с классами 
(если дать классу и пространству имен одно и то же имя, они будут слиты. Результат - вложенная структура, которая походит на внутренние классы из других языков программирования)
- пространств имен с функциями
(это позволяет присваивать функциям значения свойств)
- пространств имен с перечислениями
(так можно создать статические члены для перечислений)

-----------------
Приращение модуля

Можно расширить существующий модуль новыми членами. Если над таким модулем работаете не вы (код 3-ей стороны).

/// classes.ts
export class UniversityLibrarian 
    implements Interfaces.Librarian, Employee, Researcher {
    
name: string;
    
  email: string;

  ...

}

/// LibrarianExtension.ts
import { UniversityLibrarian } from './classes';



declare module './classes' {
    
    interface UniversityLibrarian {
        
        phone: string;
        
        hostSeminar(topic: string): void;
    
    }

}



UniversityLibrarian.prototype.hostSeminar = function(topic) {
    
    console.log('Hosting a seminar on ' + topic);

}


Теперь для объекта UniversityLibrarian можно вызывать свойство phone и метод hostSeminar().

-----------
Type Guards

Это способ проверить тип переменной
+ способ для компилятора сузить переменную до заданного типа.

=> проверка ошибок на этапе компиляции.

Есть несколько способов реализовать type guard.

1) Через typeof.

let x: string | number = 123;
if (typeof x === 'string') {
  ...
}

Такой тайпгард работает только с типами string, number, boolean и symbol.

2) Через instanceof.

x instanceof Phone
проверяет, что переменная слева имеет в цепочке прототипов конструктор Phone.

3) User-defined type guards.

interface Vehicle {...}

function isVehicle(v: any): v is Vehicle {
    return (<Vehicle>v).numberOfWheels !== undefined;
}
- здесь задан т.н. предикат типа как возвращаемое значение функции.

=======
Symbols

Фича ES2015, принятая TypeScript.

Новый примитивный тип данных с особым набором возможностей.
* единственность
* неизменяемость

Случаи использования:
1) Уникальные константы.
Например, для релизации объектов ES2015, ведущих как перечисления. Но в TS это не надо, там перечисления и так есть встроенные.
2) Объявления вычисляемых свойств.
3) Кастомизация внутреннего поведения языка. (переопределение встроенных в язык значений)

Символы - фича ES2015, поэтому для target=ES5 она не подойдет.


