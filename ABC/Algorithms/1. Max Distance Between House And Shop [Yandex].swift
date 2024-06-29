/*
Дан массив чисел, 0 - жилой дом, 1 - магазин, 2 - офисное здание.
Найти максимальное расстояние между жилым домом и магазином.
*/

func findMaxDistance(_ nums: [Int]) -> Int {
  let n = nums.count
  var maxDistance = 0
  var shopFromRight = Array(repeating: -1, count: n)
  var shopFromLeft = Array(repeating: -1, count: n)
  var currentIndex = -1

  for i in 0..<n {
    if nums[i] == 1 {
      currentIndex = i
    }

    shopFromLeft[i] = currentIndex
  }

  currentIndex = -1

  for i in (0..<n).reversed() {
    if nums[i] == 1 {
      currentIndex = i
    }

    shopFromRight[i] = currentIndex
  }

  for i in 0..<n where nums[i] == 0 {
    var dR = Int.max

    if shopFromRight[i] != -1 {
      dR = shopFromRight[i] - i
    }

    var dL = Int.max

    if shopFromLeft[i] != -1 {
      dL = i - shopFromLeft[i]
    }

    let d = min(dR, dL)

    maxDistance = max(maxDistance, d)
  }

  return maxDistance
}
