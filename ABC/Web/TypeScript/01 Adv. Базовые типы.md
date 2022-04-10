Advanced Базовые типы.

------------------------------
Реструкция массивов и объектов

Реструктивное присваивание - процесс присваивания элементов массива или свойств объекта отдельным переменным.

Есть специальный синтаксис для выполнения этого чистым и четким образом.

Деструктурирование массивов:

Вместо

let medals: string[] = ['gold', 'silver', 'bronze'];

let first: string = medals[0];
let second: string = medals[1];
let third: string = medals[2];

Можно сделать это одной строкой кода

let [first, second, third] = medals;

Деструктурирование объектов:

let { name, address, phone } = person;

если имена не соответствуют:

let { title: booktitle, author: bookauthor } = book1;
слева имя свойства объекта, справа - имя переменной.

rest-параметр массива:

function LogFavBooks([book1, book2, ...others]: Book[]): void {
    ...
}

others - новый массив с оставшимися элементами

---------------
Spread-оператор

Позволяет "распространить" элементы массива среди элементов нового массива или даже набора параметров функции.

let bookIDs = [10 , 11];
let allBookIDs = [1, 2, 3, ...bookIDs];
В методе push() массива можно использовать spread-оператор:

books.push(...schoolBooks);


Т.е. этот оператор можно использовать в аргументах функций.

--------------
Кортежные типы

Это тип, объединяющий набор свойств, именованных числовым образом, с членами типа-массива.

let myTuple: [number, string] = [10, 'Mac'];

имя переменной \ тип кортежного типа - список типов, разрешенных для каждого элемента массива

Кортежи расширены к массивам.
Тип задан для фиксированного числа элементов.

Элемент может содержать разные типы.

Манипулировать кортежем можно по индексу, как в массиве

myTuple[0]

myTuple[2] можно задавать произвольным типом.

--------------------
Комбинирование типов

Union типы 

function PrintId(id: string | number) {
    ...
}

Union типы позволяют задать несколько валидных типов для значения. Валидные типы разделяются вертикальной чертой.

intersection типы
задают значение, которое будет содержать все члены от нескольких типов:

function CreateCoolNewDevice(): Phone & Tablet {

}

-----
Mixin

Это просто классы, чью функциональность вы добавляете к некоторым другим классам.

Пусть у нас есть классы Employee и Researcher, и мы хотим третий класс с функциональностью обоих.

class Employee {
    title: string;
    addToSchedule(): void {
	}
    logTitle(): void {
    }
}

class Researcher {
    doResearch(topic: string): void {
    }
}

class UniversityLibrarian implements Interfaces.Librarian, Employee, Researcher {   
    name: string;
    email: string;
    department: string;
    
    assistCustomer(custName: string) {
    }

    title: string;
    addToSchedule: () => void;
    logTitle: () => void;
    doResearch: (topic: string) => void;    
}

- Последние 4 строки - это объявление членов Employee и Researcher, реализация которых будет предоставления mixin-функцией:

function applyMixins(derivedCtor: any, baseCtors: any[]) {
    baseCtors.forEach(baseCtor => {
        Object.getOwnPropertyNames(baseCtor.prototype).forEach(name => {
            derivedCtor.prototype[name] = baseCtor.prototype[name];
        });
    });
}

applyMixins(UniversityLibrarian, [Employee, Researcher]);

Объект UniversityLibrarian создается обычным образом:

let universityLibrarian = new UniversityLibrarian();

-----------------------
Тип строкового литерала

Это действительно особый тип.

let empCategory: 'Manager';
let empCategory: 'Manager' = 'Manager';
let empCategory: 'Manager' = 'Non-manager'; // ERROR
let empCategory: 'Manager' | 'Non-manager';
let empCategory: 'Manager' | 'Non-manager' = 'Manager';
let empCategory: 'Manager' | 'Non-manager' = 'Non-manager';

----------------
Псевдонимы типов

Способ сослаться на тип по другому имени.

type EmployeeCategory = 'Manager' | 'Non-manager';
