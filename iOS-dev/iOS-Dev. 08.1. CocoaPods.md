# iOS-Dev. 08.1. CocoaPods.

### Основы

```
pod --version
pod init // создает в директории проекта podfile, в котором мы опишем зависимости
open PodFile
```

Хотим заюзать аламофайр. Добавляем его в podfile.

Потом идём в консоль. Пишем `pod install`. Версию 5 не может найти, если написать 4.0, то может.

Дальше cocoapods подсказывает закрыть XCode и открыть сгенерированный workspace. 

В воркспейсе теперь есть 2 проекта - отдельно проект подов (таргет аламофаера).

---

__Development pod__ - pod, который устанавливается с папки на диске. И в структуре папок  проекта XCode будут Development Pods, и там будут файлы подов, которые установлены локально.

Development pod'ы изначально появились для того, чтобы мы могли разрабатывать pod, но они очень часто используются для того, чтобы делать модульность. Через development pod'ы  легко и удобно настраиваются дополнительные проекты, которые собираются в свои фреймворки и подключаются в основной проект. 

В общем случае для работы с дополнительными подами нужно в Podfile указать для CocoaPods, где ему искать файл .podspec.

subspec - это такое описание Вашего проекта, Вашего кусочка кода, который вы можете подключать, а можете нет. Pod можно подключать не целиком, а кусочками, если он это поддерживает.

---

app_spec - это сабспека, которая создаёт отдельный таргет, но уже с запускаемым приложением.

На app_spec в Яндекс.Картах построена автоматическая генерация тестовых проектов. Мы создаём модуль, в нём автоматически создаётся тестовый проект, и он подключается как раз через app_spec'у.

В Яндекс Картах для каждого feature-модуля существует свой отдельный development pod, в котором есть его тесты (test_spec) и его тестовый проект (app_spec). Чтобы было быстрее собирать этот кусочек приложения и удобнее его дебажить.

Пример .podspec файла с несколькими subspec.

```
Pod::Spec.new do |spec| spec.name = 'MyPod'
  spec.subspec 'Core' do |sp| ...
  end
  spec.subspec 'AdditionalFunctions' do |sp|
  ...
  end
  spec.test_spec do |test_spec|
  ...
  end
  spec.app_spec do |app_spec|
  ...
  end
end
```

`spec.default_subspecs = [‘Core', ‘UI']` - массив тех сабспек, которые будут подключены по умолчанию.

Пример того, как подключить отдельные сабспеки.

```
target 'MyApp' do

  pod 'AFNetworking', '= 4.0.1',
    :subspecs => ['Serialization', 'Reachability'], 
    :testspecs => ['UnitTests', 'SomeOtherTests'], :appspecs => ['Sample']

  pod 'QueryKit/Attribute'
end
```

---

Что такое Xcode project entitlements?

__Entitlements__

Key-value pairs that grant an executable permission to use a service or technology.

An entitlement is a right or privilege that grants an executable particular capabilities. For example, an app needs the HomeKit Entitlement — along with explicit user consent — to access a user’s home automation network. An app stores its entitlements as key-value pairs embedded in the code signature of its binary executable.

You configure entitlements for your app by declaring capabilities for a target in Xcode. Xcode records capabilities that you add in a property list file with the .entitlements extension. You can also edit the entitlements file directly. When code signing your app, Xcode combines the entitlements file, information from your developer account, and other project information to apply a final set of entitlements to your app.