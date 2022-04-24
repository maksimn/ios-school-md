# UIKit. UIView.

## Autolayout 

Autolayout - это способ адаптации графического интерфейса под разные размеры экрана / разную ориентацию экрана устройства.

(2-й способ - ручное управление размерами представлений через фреймы)

C iOS 11 введено понятие Safe area - область, которая не перекрывается конструктивными элементами телефона (например, чёлкой айфона 10).

## Жесты касания рекогнайзера

`UIGestureRecognizer`

https://medium.com/yandex-maps-ios/uigesturerecognizer-tutorial-83f2128e479d

Делали ячейки на фреймах, сегодня будем рассматривать констрейнты. [32:21]

# Constraints

Они позволяют достаточно быстро и просто создавать интерфейсы, которые адаптируются под различные размеры. Под iPad, iPhone разных размеров - просто задаются границы слева-справа-сверху-снизу и всё под них перестраивается за счёт внутренних алгоритмов. Но цена этого - удар по производительности. В сложных интерфейсах мб заметное падение FPS и тормоза. Поэтому в них мб лучше использовать фреймы.

На текущий момент из коробки можно делать констрейнты 3 способами.

1 - просто описание `NSLayoutConstraint` с каким-то интерфейсом, огромной простыней с параметрами.

2 - Потом появился Visual Format, со специфичной реализацией. Описываем в строке, расстояния, от границы экрана... "мне это не зашло" (с).

Потом появились различные абстракции, у нас в проекте появилась библиотека Masonry от Snapkit. Имеет более удобный синтаксис, с ней проще работать.

3 - Новый способ создания констрейнтов - якоря (anchors). Это достаточно простой интерфейс, разработанный позже первый, его уже можно использовать. 

### NSLayoutConstraint

У констрейнтов мб разный приоритет (свойство priority). В зависимости от их значений элементы по разному растягиваются и размещаются.

Приоритет на расширение (по вертикали). Приоритет на сжатие.

---

### Masonry

github shapkit в поиске по сайту https://github.com/SnapKit/Masonry

---

## Практика по constraints.

Первое задание на занятии - предыдущую верстку ячеек таблицы сделать на констрейнтах и якорях. 

Второе задание - переписывание под динамическую высоту ячеек (на констрейнтах).

Динамический расчет - если делать на фреймах, то нужно для каждого нового `layoutSubviews` для каждого текста рассчитывать его размер. Для этого есть несколько методов: 

`sizeToFit` - из коробки он оптимизирует под текущий фрейм текст, вписывает его и возвращает label под конкретный фрейм. 

`sizeToFit` под определенный size. 

Есть boundingRect, который работает в том числе с атрибутами строки. Учитывает межстрочное расстояние, настройки самого текста.

Это достаточно простая, но рутинная работа, поэтому с помощью констрейнтов можно сделать достаточно просто такие простые вещи для ресайзинга. Их тоже можно делать различными способами.

---

У нас есть метод `layoutSubviews`, в котором происходила вёрстка на фреймах:

```objectivec
@implementation AnimalTableViewCell

/// ...

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.coverImageView.frame = CGRectMake(16.f, 16.f, 40.f, 40.f);
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.coverImageView.frame) + 16.f, 16.f, 
	                                   CGRectGetWidth(self.frame) - 88.f, 16.f);
    self.subtitleLabel.frame = CGRectMake(CGRectGetMaxX(self.coverImageView.frame) + 16.f, 
	                                      CGRectGetMaxY(self.titleLabel.frame) + 16.f,
                                          CGRectGetWidth(self.frame) - 88.f, 16.f);
}

@end
```

Почему не стоит писать констрейнты? Из-за затратных вычислений, которые будут постоянно вызываться.

Для задания констрейнтов лучше создать отдельный метод и вызвать его при инициализации интерфейса.

```objectivec
#import "AnimalTableViewCell.h"


@interface AnimalTableViewCell ()

@property (nonatomic, strong) NSLayoutConstraint *topCoverImageConstraint;

@end


@implementation AnimalTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

	if (self)
	{
        UITapGestureRecognizer *tapOnCoverImage = [[UITapGestureRecognizer alloc] initWithTarget:self 
		    action:@selector(didTapCoverImage)];
        
		_coverImageView = [UIImageView new];
		_coverImageView.backgroundColor = [UIColor yellowColor];
        _coverImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _coverImageView.userInteractionEnabled = YES;
        [_coverImageView addGestureRecognizer:tapOnCoverImage];
		[self.contentView addSubview:_coverImageView];

		_titleLabel = [UILabel new];
		_titleLabel.backgroundColor = [UIColor greenColor];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[self.contentView addSubview:_titleLabel];

		_subtitleLable = [UILabel new];
		_subtitleLable.backgroundColor = [UIColor blueColor];
        _subtitleLable.numberOfLines = 0; // так текст делается многострочным
        _subtitleLable.translatesAutoresizingMaskIntoConstraints = NO;
		[self.contentView addSubview:_subtitleLable];
        
        [self makeConstraints];
	}

	return self;
}

- (void)makeConstraints
{
    NSLayoutConstraint *bottomConstraint = [
	    _subtitleLable.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor        
		                            constant:-16.f
	];
    bottomConstraint.priority = UILayoutPriorityDefaultHigh; // Для корректного ресайза под 
	                                                         // динамическую высоту
    
    self.topCoverImageConstraint = [
	    _coverImageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:16.f
	];
    
	[NSLayoutConstraint activateConstraints:@[
            [_coverImageView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor 
			                            constant:16.f],
            self.topCoverImageConstraint,
            [_coverImageView.widthAnchor constraintEqualToConstant:40.f],
            [_coverImageView.heightAnchor constraintEqualToConstant:40.f],
            [_titleLabel.leftAnchor constraintEqualToAnchor:_coverImageView.rightAnchor constant:16.f],
            [_titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:16.f],
            [_titleLabel.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:-16.f],
            [_titleLabel.heightAnchor constraintEqualToConstant:16.f],
            [_subtitleLable.leftAnchor constraintEqualToAnchor:_coverImageView.rightAnchor constant:16.f],
            [_subtitleLable.topAnchor constraintEqualToAnchor:_titleLabel.bottomAnchor constant:16.f],
            [_subtitleLable.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:-16.f],
            bottomConstraint
        ]
    ];
}

@end
```

Метод `NSLayoutConstraint activateConstraints` на вход принимает массив заданных констрейнтов.

Далее - сделать констрейнты для ячейки другого типа и для Birds Collection View. Сейчас.

Самая большая проблема фреймов - нет приоритетов. Из-за этого получается слишком много логики. Произвольные размеры задать-то можно - в зависимости от bounds родителя.

Для динамического расчета высоты на фреймах надо сделать больше приседаний.

