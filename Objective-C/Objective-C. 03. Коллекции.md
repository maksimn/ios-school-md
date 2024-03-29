# Obj-C

## Коллекции

Есть 2 варианта коллекций - мутабельные и немутабельные.


## Массив NSArray

__Способы создания массива:__

```objectivec
// 1
NSArray *animals = @[@"Cat",@"Dog", @"Bird"];
// 2
NSArray *animals = [[NSArray alloc] initWithObjects:@"Cat",@"Dog",
@"Bird", nil];
```

С точки зрения создания и управления памятью эти 2 способа отличаются.

__Способы обхода массива:__

1. Через обычный цикл с индексом
2. Fast enumeration
3. Через специальный метод `enumerateObjectsUsingBlock`, в который передаётся блок.

Аналогичные 3 способа есть для обхода словаря `NSDictionary`.

### Операции с массивами `NSArray`

* __Сравнение массивов__ - метод `isEqualToArray`.
* __Проверка элемента на вхождение__ - метод `containsObject`
* __Сортировка__ - метод `sortedArrayUsingComparator`
* __Фильтрация__ - метод `filteredArrayUsingPredicate`
* Выделение подмассива
* Объединение элементов двух массивов - `arrayByAddingObjectsFromArray`
* Обход в обратном порядке
* Бинарный поиск (в отсортированном массиве) - метод `indexOfObject` с параметром `NSBinarySearchingFirstEqual`

---

Изменяемый массив - `NSMutableArray` является непотокобезопасным при добавлении/удалении элементов.

---

Чтобы перейти из изменяемого массива к неизменяемому, нужно послать сообщение `copy`. 

Обратное преобразование - сообщение `mutableCopy`.

---

Структура данных для `NSDictionary` - красно-черное дерево.

Структура данных для `NSSet` - хэш-таблица.

---

Домашнее задание

Рассмотреть коллекции `NSPointerArray`, `NSHashTable`, `NSMapTable`, описать несколько примеров их использования, написать код, разобраться чем данные коллекции отличаются от `NSArray`, `NSSet`, `NSDictionary`.

Рассмотреть дополнительные виды множеств `NSCountedSet`, `NSOrderedSet`.

1) Написать, какие классы они наследуют, какие протоколы реализуют. Какие у них свои методы их API.

2) Для чего их можно использовать? Для каких задач они созданы?

### NSPointerArray

Базовый класс - напрямую `NSObject`.

Протоколы: `NSCopying`, `NSFastEnumeration`, `NSSecureCoding`.

Производных классов не имеет.

The pointer array class is modeled after NSArray, but can also hold nil values. You can insert or remove nil values which contribute to the array's count.

A pointer array can be initialized to maintain strong or weak references to objects, or according to any of the memory or personality options defined by NSPointerFunctionsOptions.

```objectivec
+ (void) pointerArrayExample {
    NSObject *someObjA = [NSObject new];
    NSObject *someObjB = [NSObject new];
    NSObject *someObjC = [NSObject new];
    
    NSPointerArray *pointerArray = [NSPointerArray strongObjectsPointerArray];
    
    [pointerArray addPointer:(__bridge void *)someObjA];
    [pointerArray addPointer:nil];
    [pointerArray addPointer:(__bridge void *)someObjB];
    [pointerArray addPointer:nil];
    [pointerArray addPointer:(__bridge void *)someObjC];
    
    for (int i = 0; i < [pointerArray count]; i++) {
        id pointer = [pointerArray pointerAtIndex:i];
        
        NSLog(@"%@", pointer);
    }
}
```

### NSHashTable

Между NSHashTable и NSSet примерно та же разница, что между NPointerArray и NSArray.

Базовый класс - напрямую `NSObject`.

Протоколы: `NSCopying`, `NSFastEnumeration`, `NSSecureCoding`.

Производных классов не имеет.

A collection similar to a set, but with broader range of available memory semantics.

The hash table is modeled after NSSet with the following differences:

* It can hold weak references to its members.
* Its members may be copied on input or may use pointer identity for equality and hashing.
* It can contain arbitrary pointers (its members are not constrained to being objects).

You can configure an NSHashTable instance to operate on arbitrary pointers and not just objects, although typically you are encouraged to use the C function API for void * pointers. The object-based API (such as addObject:) will not work for non-object pointers without type-casting.

Because of its options, NSHashTable is not a set because it can behave differently (for example, if pointer equality is specified two isEqual: strings will both be entered).

When configuring hash tables, note that only the options listed in NSHashTableOptions guarantee that the rest of the API will work correctly—including copying, archiving, and fast enumeration. While other NSPointerFunctions options are used for certain configurations, such as to hold arbitrary pointers, not all combinations of the options are valid. With some combinations the hash table may not work correctly, or may not even be initialized correctly.

### NSMapTable

Базовый класс - напрямую `NSObject`.

Протоколы: `NSCopying`, `NSFastEnumeration`, `NSSecureCoding`.

Производных классов не имеет.

The map table is modeled after NSDictionary with the following differences:

* Keys and/or values are optionally held “weakly” such that entries are removed when one of the objects is reclaimed.
* Its keys or values may be copied on input or may use pointer identity for equality and hashing.
* It can contain arbitrary pointers (its contents are not constrained to being objects).

You can configure an NSMapTable instance to operate on arbitrary pointers and not just objects, although typically you are encouraged to use the C function API for void * pointers. The object-based API (such as setObject:forKey:) will not work for non-object pointers without type-casting.

When configuring map tables, note that only the options listed in NSMapTableOptions guarantee that the rest of the API will work correctly—including copying, archiving, and fast enumeration. While other NSPointerFunctions options are used for certain configurations, such as to hold arbitrary pointers, not all combinations of the options are valid. With some combinations the map table may not work correctly, or may not even be initialized correctly.

### NSCountedSet

A mutable, unordered collection of distinct objects that may appear more than once in the collection.

```objectivec
@interface NSCountedSet<__covariant ObjectType> : NSMutableSet
```

Each distinct object inserted into an NSCountedSet object has a counter associated with it. NSCountedSet keeps track of the number of times objects are inserted and requires that objects be removed the same number of times. Thus, there is only one instance of an object in an NSSet object even if the object has been added to the set multiple times. The count method defined by the superclass NSSet has special significance; it returns the number of distinct objects, not the total number of times objects are represented in the set. The NSSet and NSMutableSet classes are provided for static and dynamic sets, respectively, whose elements are distinct.

### NSOrderedSet

A static, ordered collection of unique objects.

```objectivec
@interface NSOrderedSet<__covariant ObjectType> : NSObject
```

NSOrderedSet declares the programmatic interface for static sets of distinct objects. You establish a static set’s entries when it’s created, and thereafter the entries can’t be modified. NSMutableOrderedSet, on the other hand, declares a programmatic interface for dynamic sets of distinct objects. A dynamic—or mutable—set allows the addition and deletion of entries at any time, automatically allocating memory as needed.

You can use ordered sets as an alternative to arrays when the order of elements is important and performance in testing whether an object is contained in the set is a consideration—testing for membership of an array is slower than testing for membership of a set.

