/*
 Есть блоки с заданной шириной и высотой, из которых строим пирамиду.
 В пирамиде один блок можно поставить на другой только если его ширина меньше ширины другого блока.
 Найти максимальную высоту пирамиды, построенной из заданных блоков.
*/

struct Size {
  let width: Int
  let height: Int
}

func findPyramidMaxHeight(_ blocks: [Size]) -> Int {
  var dict: [Int: Int] = [:]

  for block in blocks {
    if let height = dict[block.width] {
      if height < block.height {
        dict[block.width] = dict[block.height]
      }
    } else {
      dict[block.width] = dict[block.height]
    }
  }

  return dict.values.reduce(0, +)
}
