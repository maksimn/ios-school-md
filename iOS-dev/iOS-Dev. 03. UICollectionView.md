# iOS-Dev. 03. 

Проблема ваших решений ДЗ -- это ваша невнимательность и скорость, с которой вы хотите их закрыть. Из-за это появляются частые ошибки.

Важность code style. Глаза вытекают от его отсутствия.

Принцип golden path - вложенность if'ов. 

```
if (условие) 
    ...
	выход
if (условие) 
    ...
	выход
```

Есть метод жирный - разбить на 2.

_In the context of software or information modeling, a happy path is a default scenario featuring no exceptional or error conditions. For example, the happy path for a function validating credit card numbers would be where none of the validation rules raise an error, thus letting execution continue successfully to the end, generating a positive response._ https://en.wikipedia.org/wiki/Happy_path

# UICollectionView

Таблицы - основной механизм. Большинство интерфейсов строятся на таблице. Но у неё есть минусы и ограничения - она не позволяет сделать сетку. И другие ограничения есть.

`UICollectionView` был разработан позднее, позволяет делать сетку с горизонтальным скроллом, вертикальным скроллом. Иметь её в виде прямоугольников различного размера в рамках одной сетки. 

UIKit поставляет библиотеку UI-элементов. Есть библиотека UIDynamics, которая позволяет "применять законы физики для конкретных UI-компонентов". Притягивание к одной из границ экрана, сила тяжести в виде падающих элементов, сталкивание двух элементов, упругость - всё это настраивается.

`UICollectionView` позволяет к этой сетке при скролле применять UIKitDynamics, чтобы по-разному всё анимировать. Например, My Message на iPhone построен на `UICollectionView`, при скролле верхние сообщения имеют разную скорость движения - такая специальная механика. 

У `UICollectionView` есть отдельный элемент - называется layout, реализует сетку. Есть стандартный layout, который со своим ... просто выравнивает элементы. Можно просто сделать кастомный layout, со своим алгоритмом расположения каждого элемента в этом лэйауте. Сколько их будет на экран помещаться, как они будут переноситься, как будет размер регулироваться -- т.е. достаточно гибкий инструмент, который можно по-разному конфигурировать. Мы сегодня сделаем обычный стд лэйаут, с квадратной кастомизированной как в таблице ячейкой. 

Делаем отдельный контроллер для отображения `UICollectionView`.

```swift
import UIKit

// open - для использования внутри проекта из кода Objective-C
open class BirdsViewController: UIViewController {

    // инициализация UICollectionView
	fileprivate lazy var collectionView: UICollectionView = {

		let collectionViewLayout = UICollectionViewFlowLayout()
		// настройка сетки
		collectionViewLayout.itemSize = CGSize(width: 100, height: 100)
		collectionViewLayout.minimumInteritemSpacing = 10
		// инициализация фреймом и лэйаутом (сетка, задающая, как отображаются элементы в коллекции)
		let collectionView = UICollectionView(frame: CGRect.zero, 
		                                      collectionViewLayout: collectionViewLayout)
		collectionView.backgroundColor = UIColor.yellow
		collectionView.dataSource = self
		collectionView.delegate = self
		// Регистрация ячейки:
		collectionView.register(UICollectionViewCell.self, 
		                        forCellWithReuseIdentifier: "CollectionViewCell")
		collectionView.register(BirdCollectionViewCell.self, 
		                        forCellWithReuseIdentifier: "BirdCollectionViewCell")

		return collectionView
	}()

	fileprivate let dataSource: [String] = ["Воробей", "Ворона", "Петух", "Пингвин"]

	open override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.red
		// добавление коллекии в иерархию вьюх:
		view.addSubview(collectionView)

		let _ = BirdCollectionViewCell()
	}

    // здесь задается фрейм для коллекции, чтобы он не был нулевого размера
	open override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		collectionView.frame = view.frame
	}
}

// Data source реализуется по тем же принципам, что для таблицы
// 2 required метода:
extension BirdsViewController: UICollectionViewDataSource {

	public func collectionView(_ collectionView: UICollectionView, 
	                           numberOfItemsInSection section: Int) -> Int {
		return dataSource.count
	}

	public func collectionView(_ collectionView: UICollectionView, 
	                           cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let birdName = dataSource[indexPath.row]

		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BirdCollectionViewCell",
		                                                 for: indexPath) as? BirdCollectionViewCell {

			cell.delegate = self
			cell.titleLabel.text = birdName
			return cell
		}
		
		return UICollectionViewCell()
	}
}

extension BirdsViewController: UICollectionViewDelegate {

	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let allertController = UIAlertController(title: "Foo Bar", message: nil, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .cancel)
		allertController.addAction(okAction)

		present(allertController, animated: true, completion: nil)
	}
}

extension BirdsViewController: BirdCellDelegate {

	func didTap(cell: BirdCollectionViewCell) {
		let allertController = UIAlertController(title: "Bang bang", message: cell.titleLabel.text, 
		                                         preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .cancel)
		allertController.addAction(okAction)
		
		present(allertController, animated: true, completion: nil)
	}
}
```

При перестроении лэйаута есть метод `invalidateLayout`, который позволяет "прибить сетку" и пересоздать её заново, перегруппировать...

Для создания своего лэйаута - наследуемся от `UICollectionViewLayout`.

Элемент birds collection view:

```swift
import UIKit

final internal class BirdCollectionViewCell: UICollectionViewCell {

	weak var delegate : BirdCellDelegate?

	let coverImageView = UIImageView()
	let titleLabel = UILabel()
	let subtitleLabel = UILabel()
	let button = UIButton()

	override init(frame: CGRect) {
		super.init(frame: frame)

		coverImageView.backgroundColor = UIColor.blue
		addSubview(coverImageView)
		addSubview(titleLabel)

		button.backgroundColor = UIColor.purple
		button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
		addSubview(button)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

    // Верстка через фреймы, та же и история, что для таблиц
	override func layoutSubviews() {
		super.layoutSubviews()

		let coverImageViewX = (frame.width - 50) / 2
		coverImageView.frame = CGRect(x: coverImageViewX, y: 10, width: 50, height: 50)

		let titleLabelY = coverImageView.frame.maxY + 5
		let titleLabelWidth = frame.width - 20
		titleLabel.frame = CGRect(x: 10, y: titleLabelY, width: titleLabelWidth, height: 10)

		let subtitleLabelY = titleLabel.frame.maxY + 5
		button.frame = CGRect(x: 10, y: subtitleLabelY, width: titleLabelWidth, height: 10)
	}

	@objc func didTap() {
		delegate?.didTap(cell: self)
	}
}
```

Делeгат нажатия по элементу:

```swift
protocol BirdCellDelegate: class {

	func didTap(cell: BirdCollectionViewCell);
}
```

При расчёте высоты с `UICollectionView` будет проблема, если каждая ячейка будет иметь динамический размер. Ячейки объединяются в row (строка таблицы), и по дефолту строка будет иметь размер высоты максимальной по высоте ячейки. Кастомный `UICollectionViewLayout` позволяет сделать, чтобы отступ под каждой ячейкой был маленький. Будет "скачущая" сетка. Можно конфигурировать сами как хотите по дизайну.

---

Добавление элементов, удаление, reload элементов, секций -- как в табличном `UITableView`.

---

У *FlowLayout еще есть направление скролла - scroll direction. Можно задать его горизонтальным, по умолчанию он вертикальный.

UICollectionViewLayoutAttributes - атрибуты для конкретного item'a.

---

В pure swift коде лучше не использовать ObjC-конструкции, включая ObjC рантайм.


[41:00] до конца

Гуглим, как реализовать кастомный collection view layout

https://www.raywenderlich.com/392-uicollectionview-custom-layout-tutorial-pinterest

__ДЗ__ - сделать такую сетку. Чтобы элементы смещались друг под друга и отступы были одинаковыми.

Чтобы нечетные были 100 (большие), четные - 50 (маленькие). Если сделаешь по контенту - будешь еще больше красавчик.

Минимальное задание - просто сделать такую сетку.

Download final project - ничего не надо делать =)

Делать на свифте можно.

---

## UITableViewController и UICollectionViewController

Над таблицами и коллекциями ещё есть абстракции - называются UITableViewController, который наследуется от UIViewController, он по умолчанию "из коробки" реализует методы Delegate и DataSource; нужно только проинициализировать с каким-то стилем или каким-то .xib'ом, у нас есть наружу торчащее свойство tableView и есть refresh control, "pull to refresh" снизу или сверху - в зависимости от того, как мы его настроим. Это позволяет вам просто запрототипировать таблицу с какими-то данными. И добавить какой-то search bar, который будет анимированно работать при переходе в него. На этом гибкость этого заканчивается, поэтому в промышленной разработке UITableViewController обычно не используется. Только при прототипировании, быстром создании чего-то. 

root view у него UITableViewController. 

UICollectionViewController - та же самая история. Тоже наследуется от UIViewController. На входе мы инициализируем наш кастомный лэйаут или Flow Layout (если пользуемся готовым). Это просто абстракция над collection view с дефолтным отображением. Сложно кастомизируется как и UITableViewController. Тоже только для прототипирования. 

