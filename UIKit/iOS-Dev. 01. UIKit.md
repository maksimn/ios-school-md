# iOS-Dev. UIKit.

## "Карта знаний" UIKit'a.

### 1. Основы UIKit.

__MVС паттерн в iOS. Его части.__

__UIKit и CALayer. iOS стек для работы с GUI.__

__Список всех готовых UI-элементов UIKit'a.__

__UIResponder, Responder chain. Метод hitTest().__

### 2. UIViewController.

__UIViewController. Его ответственности. Виды поведения view controller'a.__

__Жизненный цикл UIViewController и его методы. Создание View Controller'a.__

__Связь модели и представления, способы. "Направление данных".__

__UIKit, UIViewController и state restoration.__

__Иерархии VC. Контейнер-контроллеры. Стандартные и кастомные.__

__Навигация в iOS приложении. Презентация UIViewController'a. UITabBarController. UINavigationController.__

__Appearance. UIAppearance.__

### 3. UIView.

__UIView. Иерархия представлений. Система координат. Bounds и frame.__ 

__Способы вёрстки представлений. Autolayout. Autoresizing mask. Constraints.__

__Важные методы UIView. intrinsicContentSize. Hugging priority. Compression resistance.__

__Size Classes.__

__Touch events. UIGestureRecognizer.__

### 4. Работа со списками.

__Сложные представления и списки. UIScrollView, UITableView, UICollectionView.__

__Кастомный лэйаут collection view.__

---

# 1. Основы UIKit.

## MVС паттерн в iOS. Его части.

`../../materials-from-prepods/uikit.pdf`

В разработке для iOS часто применяется паттерн MVC:

* _View_ - __Component__ (название в iOS-разработке) - компонент есть элемент пользовательского интерфейса (напр., кнопка)

* _Model_ - __DataSource__ - предоставляет данные для приложения

* _Controller_ - __Delegate__ - управляет потоком данных в приложении и тем, какое представление отобразить на экране.

## UIKit и CALayer. iOS стек для работы с GUI приложения.

`../../materials-from-prepods/uikit.pdf`

## Список всех готовых UI-элементов UIKit'a.

```
UIView

UILabel    UIButton    UITableView    UICollectionView   UISegmentedControl  UITextField

UISlider    UISwitch    UIActivityIndicatorView    UIProgressView    UIPageControl  UIStepper

UIStackView  UITableViewCell  UICollectionViewCell  UIImageView  UICollectionReusableView 

UITextView  UIScrollView  UIDatePicker  UIPickerView  UIVisualEffectView  MKMapView  MTKView 

GLKView   SCNView  SKView  ARSCNView  ARSKView  UIWebView  WKWebView  ARView  CLLocationButton

UIContainerView  UINavigationBar  UINavigationItem  UIToolbar  UIBarButtonItem  UITabBar  

UITabBarItem  UISearchBar  UICommand  UIMenu  
```

## UIResponder, Responder chain. Метод hitTest().

`../../materials-from-prepods/uikit.pdf`

