# iOS-Dev. 13.

# Core Data

Для чего вообще нужен Core Data? Для сохранения данных в приложении. Например, он часто используется для оффлайн работы приложения. Сетевой слой создается так, что кэширует все свои сущности в Core Data.

Недостатки: Core Data очень сложен, высокий порог вхождения))


Есть миграция. 

Уменьшает количество кода, но удваивает количество багов)). 

`NSManagedObjectContext`  управляет набором объектов модели, экземплярами класса NSManagedObject.

`NSManagedObjectModel` описывает сущности данных и отношения между ними. Модель хранится в бандле с расширением `.xcdatamodel` и при сборке проекта компилируется в файл с расширением `.momd`. 

Сущности Core Data могут быть абстрактными (как классы) и наследоваться другими сущностями.

`NSManagedObjectModel` создаются в некотором контексте, и операции, которые можно с ними осуществить, должны выполняться в этом же контексте. `NSManagedObjectContext` это кэш, который существует в памяти, где лежат репрезентации наших моделей. Модели лежат в сторе - хранилище. 

`NSPersistentStoreCordinator` - координирует всеми и позволяет существенно всё упростить. 

Managed Object Id - id из стора, с помощью которого можно из разных контекстов работать с managed object'ом. 

Persistent Container объединяет в себе все эти части системы - Persistent Store Coordinator, Managed Object Context, Managed Object Model. С ним очень удобно работать, мы его потыкаем. 

Если Вам нужно создавать ваши сторы моделей, то это можно через New File.

Есть сущности (entities), их атрибуты, и связи.

В AppDelegate.m создается Pesistent Store Container:

```objectivec
#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns 
    // a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"coreData112"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:
                                  ^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. 
                    // You should not use this function in a shipping application, although 
                    // it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection 
                       when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}
```

В Core Data можно сделать code gen, а можно писать руками. Мы за ручной труд и руками прописываем классы managed object'а. 

---

`NSManagedObject` - объект модели в Core Data:

```objectivec
//  Person+CoreDataClass.h
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Phone;

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSManagedObject

/* в файле реализации пустая область реализации */

@end

NS_ASSUME_NONNULL_END

#import "Person+CoreDataProperties.h"
```

Чтобы Core Data заработала, нужно добавить свойства к модели, 
которые должны быть динамическими в рантайме:

```objectivec
//  Person+CoreDataProperties.h
#import "Person+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *surName;
@property (nullable, nonatomic, retain) Phone *phone;

@end

NS_ASSUME_NONNULL_END
```

файл реализации:

```objectivec
//  Person+CoreDataProperties.m
#import "Person+CoreDataProperties.h"

@implementation Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Person"];
}

@dynamic name; // dynamic означает, что есть setter и getter, но нет имплементации
@dynamic surName; // имплементацию подставляет фреймворк Core Data на старте, когда он начинает 
@dynamic phone; // разбирать всё это дело

@end
```

Вторая сущность `Phone` добавлена для демонстрации связей. 
(XCode: Editor -> Create NSManagedObject subclass).

---

Что у нас во ViewController'e? Search bar, table view, добавить нового пользователя, сортировка какая-то... запустим, посмотрим. 

Если удалить приложение, то всё, что в папке для sandbox этого приложения, тоже удалится. То есть данные для Core Data удалятся вместе с приложением.

---

Старайтесь никогда не хранить NSManagedObject'ы в массивах, 
в свойствах или как-то перекидывать их между экранами. 
Потому что как только изменяется контекст, то все managed 
object'ы, которые связаны с этим контекстом, перестают быть 
валидными. Если к ним обратиться, что-то изменять, то будет 
очень неприятный крэш.

---

На уровне представления или на презентационном слое (напр., 
ViewController) не должно быть никаких сущностей модели данных, 
не должно быть сущностей Core Data.

На уровне представления должна быть __*модель представления*__. 

Для передачи модели из одного слоя в другой используют 
data transfer object (DTO).

---

Устраняйте из проектов дублирование кода - мы на это будем смотреть.

В момент `save:` то, что находится в `NSManagedObjectContext`, записывается в стор.

```objectivec
[self.coreDataContext save:nil];
```

Минус одного контекста - 1. из одного потока, 2. из главной очереди - фриз экрана

Для этого создают private context background-очереди...

--- 

Оставшаяся часть программы - посмотреть fetch result controller и наладить отношения между сущностями.

Работать не блокируя main-поток.

(Fetched Results Controller в Сбере deprecated вроде).

---

Посмотрели `NSFetchedResultsController`, теперь создаем сущность `Phone`, с отношением к сущности `Person`.

---

Проект - `coreData112` из папки `xcode_projects`.

---

Миграция. Простая миграция. Кастомная сложная миграция пишется самостоятельно. 

Простое добавление полей работает из-коробки. Если optional-поле, то вообще ничего делать не надо.


## Получение данных с помощью NSFetchRequest

У нас есть Table View, содержащее список организаций.

`NSFetchRequest` -- класс, использующийся для получения данных; имеет обширный набор параметров.

`request.fetchLimit` - органичение количества данных в результате запроса.
 
`request.fetchOffset` - смещение выдачи относительно начала.

`request.predicate` - предикат для запроса.

`request.sortDescriptors = [ sortDesc ]` - задать способ сортировки результатов запроса.


## NSFetchedResultsController

Более гибкий механизм получения данных. Очень удобен для использования с UITableView и UICollectionView благодаря методам делегата, которые с легкостью позволяют отслеживать добавление, удаление и изменение данных.

Также он, в отличие от `NSFetchRequest`, уведомляет об изменениях, произошедших в контексте. Он отслеживает их через нотификации. 

Плюс он может кэшировать данные.

```swift
class OrganizationsViewController : UIViewController {
    private var fetchedResultsController: NSFetchedResultsController<Organization>?
	
	// метод создания и конфига NSFetchedResultsController'a
	func setupFetchedResultsController(for context: NSManagedObjectContext) {
	    // ...
	}
}

extension OrganizationsViewController : NSFetchedResultsControllerDelegate {

}
```

## Управление памятью и Core Data

`NSMO` содержится в слабой (по умолчанию) ссылке в `NSMOContext`, у которого он зарегистрирован. 

Слабые ссылки можно поменять на сильные.

__Faulting__ - механизм, позволяющий уменьшить объем занимаемой памяти при работе с Core Data.

## Валидация данных в Core Data

---

### Вопросы:

1. Что такое стек Core Data?
2. Что такое `NSManagedObjectContext`?
