# iOS-Dev. 04. 

## Анимация в tableview и collectionview. 

Анимация через CALayer, View Animations и всё остальное. 

Также здесь рассмотрены констрейнты - инструмент для создания визуальных иерархий, сеток определенных, как они располагаются, по каким правилам, кто на кого как влияет по какому отношению, как это масштабируется и рассчитывается динамически.

## CALayer.

У каждой вьюхи есть дефолтный `CALayer`. Есть свойство `layer`. Это базовый layer, с которым можно делать анимации.

`CALayer` - абстракция над __Core Animations__, оно - абстракция над OpenGL (теперь Metal - абстракция над GPU). 

`CALayer` отвечает за полноценное отображение элемента на экране - за рендеринг. `UIView` (__UIKit__) - помимо отображения реализует обработку нажатий.

`CALayer` можно конфигурировать, создавать саблэйеры и собирать всё в рамках одной вьюхи. Это более оптимизированный способ, чем вкладывать вьюхи через сабвьюхи. Но есть ограничения.

Это `layer` можно переопределить у наследника `UIView`, и сделать какой-то свой лэйер. Есть различные типы `CALayer`:

`presentationLayer`

`modelLayer`

Например, у `UIView` нет интерфейса, связанного с заданием скругленных углов, теней. Эти свойства реализует сам layer, который отображает конкретный элемент на экране.


`CAGradientLayer` - можно в качестве layer задать это, и в нем задать цвета по градиенту, как список через массив colors.

`CAShapeLayer`

`CATextLayer`

и другие. Из коробки предоставляют определенную функциональность.

Посмотрите дома про каждый тип лейера, что он даёт. Рекомендую плотненько подсесть на документацию.

---

## Customizing Collection View Layouts

Настройка лэйаута для `UICollectionView`:

* `MosaicLayout`,
* `ColumnFlowLayout`

https://developer.apple.com/documentation/uikit/uicollectionview/customizing_collection_view_layouts?language=objc

В сложных интерфейсах `UICollectionView` позволяет делать достаточно гибкий лэйаут. Настраивается в зависимости от положения экрана в том числе. Больше возможностей из коробки, чем у таблиц.

_В сберовском приложении поворачивается при повороте экрана?_

Нет. Только портретный режим. Не спрашивай, почему.

---

## Пример анимации на констрейнтах в таблице

Например, чтобы картинка при нажатии на неё съезжала вниз (или чтобы оказывалась посередине ячейки независимо от её размера).

У всех вьюх есть constraints - массив констрейнтов. Искать нужно ограничение до нему - такое себе занятие. Чтобы заменить, удалить - изменить конфигурацию.

Создадим свойство, вынесем его отдельно (см. `topCoverImageConstraint`).

```objectivec
- (void)didTapCoverImage
{
    [self.coverImageView removeConstraint:self.topCoverImageConstraint];
    NSLayoutConstraint *alignCenterYConstraint = [self.coverImageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor];
    [self.contentView addConstraint:alignCenterYConstraint];
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded]; // необходимо вызвать, чтобы перестроение имело место
    }];
}
```

__Домашнее задание__: хочется, чтобы вы при скролле таблицы или коллекции анимировали сами ячейки. Трясли их по-разному, с различными эффектами. Анимировали появление этих ячеек на экране. 

Можно сделать различными способами. Есть метод делегата will display cell, он позволит вам анимировать саму ячейку.

Анимацию ячейки нужно сделать через `CAAnimation`. Ещё нужно будет у каждой ячейки поменять базовый layer на свой тип. Сейчас CALayer, сделать CAGradientLayer. 

В этом методе через CAAnimation применить какие-то эффекты анимации.

Можно и через UIView animation, но это easy way. 

Или есть

```
[UIView animateWithDuration:<#(NSTimeInterval)#> delay:<#(NSTimeInterval)#>
 usingSpringWithDamping:<#(CGFloat)#> initialSpringVelocity:<#(CGFloat)#>
  options:<#(UIViewAnimationOptions)#> animations:<#^(void)animations#> 
  completion:<#^(BOOL finished)completion#>];
```

В общем, чтобы при скролле таблицы появление каждой ячейки анимировалось. Двигается, прыгает, скачет, сгорает - всё, что угодно. Чем больше анимаций, тем лучше. И поменять базовый layer ячейки таблицы.

Можно через key frame animation, caanimation.
