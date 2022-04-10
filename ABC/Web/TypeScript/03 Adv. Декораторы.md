## TS. Декораторы.

Это фича ES2015, принятая и тайпскриптом.

Декораторы декларативны ("что делать", а не "как делать").

Это куски функциональности, которые вы можете добавлять в классы, методы, свойства, параметры, get- set- методы с очень простым синтаксисом.

Они играют важную роль в нескольких важных клиентских фреймворках типа Ангуляра 2.

Декораторы похожи на атрибуты С#.

Декораторы реализуются просто как функции.
Они могут иметь разные сигнатуры в зависимости от того, какие конструкции они декорируют.

Опция компилятора: `experimentalDecorators`.


### Синтаксис декораторов и фабричные функции

Пример декоратора класса:

```typescript
function uielement(target: Function) { 
    // do ui stuff 
}
```

Декоратор класса принимает единственный параметр - функцию-конструктор класса.

Тип декоратора класса

```typescript
<TFunction extends Function>(target: TFunction) => TFunction | void;
```

`TFunction` - тип функции-конструктора класса. Она будет передана как параметр.

Есть 2 способа использовать декораторы классов, и они представлены двумя возможными возвращаемыми типами.

1) Замещение существующего конструктора (возвр. `TFunction`). Возвращаемое значение становится новым конструктором для класса.

2) Возврат void. В этом случае исходный конструктор остается на месте. Логика функции будет исполнена как для любой другой функции.

Пример: определение декоратора sealed, применяемого к классам, к которым мы хотим запретить добавление новых свойств.

```typescript
export function sealed(target: Function): void {
    Object.seal(target);
    Object.seal(target.prototype);
}
```

```typescript
@sealed
class SomeClass {
}
```


### Декоратор класса, замещающий конструктор

```typescript
export function logger<TFunction extends Function>(target: TFunction): TFunction {
    let newConstructor: Function = function() {
        console.log('Creating new instance');
        console.log(target);
    }
    newConstructor.prototype = Object.create(target.prototype);
    newConstructor.prototype.constructor = target;
    return <TFunction>newConstructor;
}
```

`TFunction` - тип замещающего конструктора


### Декоратор метода (принимает уже 3 параметра):

```typescript
function deprecated(t: any, p: string, d: PropertyDescriptor) {
    console.log('This method will go away soon.');
}
```

1-й параметр: функция-конструктор для статического метода или прототип для класса (если декорируется член экземпляра).
2-й параметр: имя декорируемого члена.
3-й параметр: дескриптор свойства для члена.

Дескриптор свойства - фича JS, добавленная в ES5. В тайпскрипт включен интерфейс `PropertyDescriptor` для упрощения работы с ним. Это объект, описывающий свойство и возможность манипуляций с ним.

```typescript
interface PropertyDescriptor {
   configurable?: boolean;
   enumerable?: boolean;
   value?: any; // значение, присвоенное свойству с данным дескриптором. 
// Если это функция, то value содержит определение функции 
   writable?: boolean; // является ли значение readonly
   get? (): any;
   set? (v: any): void;
}
```

Декоратор метода может возвращать новый дескриптор свойства, но это не необходимо.

Применение декоратора

```typescript
@uielement
class ContactForm {
    @deprecated
    someOldMethod() { ... }
}
```

конструктор класса автоматически будет передан как параметр функции `uielement`, так что самому записывать в него какие-то параметры не нужно. Аналогично декоратор метода.

### Фабрики декораторов

Они позволяют задавать дополнительные параметры при применении декоратора.

```typescript
function uielement(element: string) {
    return function(target: Function) {
        console.log(`Creating new element: ${element}`);
    }
}

@uielement('Form')
class Form {
    ...
}
```


### Декораторы свойств и параметров

Способ их создания и использования очень похож на декораторы классов.

```typescript
function MyPropertyDecorator(target: Object, propertyKey: string) {
    ...
}
```

1-й параметр: функция-конструктор класса, содержащего декорируемый член, если этот член определен как статический. В ином случае это прототип для класса, содержащего данный член. 

2-й параметр: имя декорируемого свойства.

### Декораторы параметров

```typescript
function MyParameterDecorator(target: Object, propertyKey: string, parameterIndex: number) {
    
}
```

3-й параметр -- индекс декорируемого параметра.


### Создание и использование декораторов методов

Декоратор метода, который не изменяется программным образом после объявления.

```typescript
export function readonly(target: Object,
                    propertyKey: string,
                    descriptor: PropertyDescriptor) {
    descriptor.writable = false;
}

class UniversityLibrarian ... {
   ...
   @readonly
   assistFaculty() {
      ...
   }
}
```
