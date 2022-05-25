# iOS-Dev. 09.

# Многопоточность

В XCode в стектрейсе можно увидеть, в каком потоке выполняется задача.

---

На одном ядре -- "конвейерная многопоточность".

---

Примеры многопоточного кода -- см. XCode проект SomeTest234.

---

Запуск ресурсоемких задач в main потоке блокирует пользовательский интерфейс.

---

__Рассмотренная задача__: запускаем некоторый метод в фоновом потоке (через `NSThread`), в нем проверяем, фоновый ли это поток, если да то запускаем анимацию в главном потоке через 

```objectivec
[self performSelectorOnMainThread:@selector(animateSomething) withObject:nil waitUntilDone:NO];
```

`waitUntilDone:NO` - выполняется параллельно, `waitUntilDone:YES` - будет ждать окончания и выполняться последовательно.

и параллельно в фоновом потоке проводим некоторые длительные вычисления.

Анимация UI в главном потоке работает асинхронно.

---

#### Самостоятельная работа по многопоточности

Задачи для самостоятельной работы:

1) single write - multiple read: реализовать не с барьером, а с семафором или мьютексом.

2) `performSelector` для `NSObject` посмотреть.

3) Треды `NSThread` (кроме pthread).

4) GCD

5) NSOperation

6) Пример задачи: вызов `dispatch_sync` внутри `dispatch_async` -- надо будет увидеть в этом deadlock. 

```objectivec
- (void)doSomeDeadLockStuff
{
    dispatch_queue_t deadLockExampleQueue = 
	    dispatch_queue_create("deadlock queue", DISPATCH_QUEUE_SERIAL);
    
    NSLog(@"1");
    dispatch_async(deadLockExampleQueue, ^{
        NSLog(@"2");
        dispatch_sync(deadLockExampleQueue, ^{
            NSLog(@"3");
            // Внешний блок ожидает завершения внутреннего блока,
            // Внутренний блок не стартанет, пока не завершится внешний
            // => deadlock
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}
```

Устройство напечатает в консоль 

```
1
5
2
```

После чего из-за дедлока произойдёт крэш `Thread 4: EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0)`.

---

Или задачи о последовательности действий -- какая будет для данного случая последовательность вызовов (через логи).

---


