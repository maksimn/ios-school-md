/*
https://contest.yandex.ru/contest/59542/problems/G/
*/

_ = readLine()

var _field: Field = []

while let line = readLine() {
  _field.append(Array(line))
}

let solution = Solution()

print(solution.solve(_field))

typealias Field = [[Character]]

class Solution {

  var n: Int = 0
  var m: Int = 0

  var field: Field = []
  var squares: [[Int]] = []

  func solve(_ field: Field) -> Int {
    self.field = field
    n = field.count
    m = field[0].count

    squares = findSquares(field)

    var kmax = 1

    var i = n / 3

    repeat {
      var j = 0

      while j + 2 * kmax <= m {
        if detectedOfficeWithSizeAt(i, j, kmax) {
          var l = kmax, h = 2 * min(n - i, m - j) / 3

          guard l < h else {
            j += 1
            continue
          }

          while l < h {
            let m = (l + h + 1) / 2

            if detectedOfficeWithSizeAt(i, j, m) {
              l = m
            } else {
              h = m - 1
            }
          }

          kmax = max(kmax, l)

          j += 1
        } else {
          j += 1
        }
      }

      i += 1

      if i + 2 * kmax > n {
        i = 0
        continue
      }

      i = i % n
    } while i != n / 3

    return kmax
  }

  func findSquares(_ field: Field) -> [[Int]] {
    let rightHistory = collectRightHistory(field)
    let downHistory = collectDownHistory(field)
    var squares = Array(repeating: Array(repeating: 0, count: m), count: n)

    let iIndices = (0..<n).reversed()
    let jIndices = (0..<m).reversed()

    for i in iIndices {
      for j in jIndices {
        if i == n - 1 || j == m - 1 {
          squares[i][j] = field[i][j] == "#" ? 1 : 0
        } else {
          guard field[i][j] == "#" else { continue }

          let kMinus1 = squares[i + 1][j + 1]

          if downHistory[i][j] >= kMinus1 && rightHistory[i][j] >= kMinus1 {
            squares[i][j] = kMinus1 + 1
          } else {
            squares[i][j] = min(rightHistory[i][j],  downHistory[i][j]) + 1
          }
        }
      }
    }

    return squares
  }

  func detectedOfficeWithSizeAt(_ i: Int, _ j: Int, _ k: Int) -> Bool {
    let i = i - k + 1
    let j = j - k + 1
    let i1 = i
    let j1 = j + k

    guard i1 > -1 && i1 < n && j1 > -1 && j1 < m else { return false }

    if squares[i1][j1] < k { return false }

    let i2 = i + k
    let j2 = j

    guard i2 > -1 && i2 < n && j2 > -1 && j2 < m else { return false }

    if squares[i2][j2] < k { return false }

    let i3 = i + k
    let j3 = j + k

    guard i3 > -1 && i3 < n && j3 > -1 && j3 < m else { return false }

    if squares[i3][j3] < k { return false }

    let i4 = i + k
    let j4 = j + 2 * k

    guard i4 > -1 && i4 < n && j4 > -1 && j4 < m else { return false }

    if squares[i4][j4] < k { return false }

    let i5 = i + 2 * k
    let j5 = j + k

    guard i5 > -1 && i5 < n && j5 > -1 && j5 < m else { return false }

    if squares[i5][j5] < k { return false }

    return true
  }

  func collectRightHistory(_ field: Field) -> [[Int]] {
    var rightHistory = Array(repeating: Array(repeating: 0, count: m), count: n)

    for i in 0..<n {
      var counter = 0

      for j in (0..<m).reversed() {
        rightHistory[i][j] = counter

        if field[i][j] == "#" {
          counter += 1
        } else {
          counter = 0
        }
      }
    }

    return rightHistory
  }

  func collectDownHistory(_ field: Field) -> [[Int]] {
    var downHistory = Array(repeating: Array(repeating: 0, count: m), count: n)

    for j in 0..<m {
      var counter = 0

      for i in (0..<n).reversed() {
        downHistory[i][j] = counter

        if field[i][j] == "#" {
          counter += 1
        } else {
          counter = 0
        }
      }
    }

    return downHistory
  }
}
