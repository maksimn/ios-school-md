/*
https://contest.yandex.ru/contest/59542/problems/I
*/

import Foundation

let _line = readLine() ?? ""
let _nums = _line.split(separator: " ").map { Int(String($0)) ?? 0 }
let _D = _nums[0]
let _N = _nums[1]
var _array: [[Int]] = Array(repeating: [], count: _N)

for i in 0..<_N {
  let _line = readLine() ?? ""
  let _nums = _line.split(separator: " ").map { Int(String($0)) ?? 0 }

  _array[i] = _nums
}

let result = solve(_D, _array)

print(result.t)
print("\(result.x) \(result.y)")

func solve(_ D: Int, _ players: [[Int]]) -> StepTwoResult {
  let one = stepOne(D, players)
  let two = stepTwo(D, one)

  return two
}

func findCatchTime2(_ x: Int, _ y: Int, _ players: [[Int]]) -> Double {
  var t2min = Double(10000000)

  for player in players {
    let dx = x - player[0]
    let dy = y - player[1]
    let vi = player[2]
    let t2 = Double(dx * dx + dy * dy) / Double(vi * vi)

    t2min = min(t2min, t2)
  }

  return t2min
}

func findCatchPositionAndTime(_ D2: Int,
                              _ xb: Int, _ xe: Int, _ yb: Int, _ ye: Int, _ players: [[Int]]) -> PositionAndTime {
  var t2max = 0.0
  var xf = 0
  var yf = 0

  for x in xb..<xe {
    for y in yb..<ye {
      guard y >= 0 else { continue }
      guard x * x + y * y <= D2 else { continue }

      let time2 = findCatchTime2(x, y, players)

      if time2 > t2max {
        t2max = time2
        xf = x
        yf = y
      }
    }
  }

  return PositionAndTime(t: t2max.squareRoot(), x: xf, y: yf)
}

func stepOne(_ D: Int, _ players: [[Int]]) -> StepOneResult {
  let pt = findCatchPositionAndTime(D * D, -D, D + 1, 0, D + 1, players)
  var resultPlayers: [[Int]] = []

  for player in players {
    let dx = Double(pt.x - player[0])
    let dy = Double(pt.y - player[1])
    let v = Double(player[2])
    let r = (dx * dx + dy * dy).squareRoot()
    let vx = v * dx / r
    let vy = v * dy / r
    let xi = Double(player[0]) + vx * pt.t
    let yi = Double(player[1]) + vy * pt.t

    if abs(xi - Double(pt.x)) <= 1.0 && abs(yi - Double(pt.y)) <= 1.0 {
      resultPlayers.append(player)
    }
  }

  return StepOneResult(x: pt.x, y: pt.y, players: resultPlayers)
}

func stepTwo(_ D: Int, _ stepOne: StepOneResult) -> StepTwoResult {
  let magnifier = 1000
  let X = stepOne.x * magnifier
  let Y = stepOne.y * magnifier
  let pt = findCatchPositionAndTime(D * D * magnifier * magnifier, X - magnifier + 1, X + magnifier, Y - magnifier + 1,
    Y + magnifier, stepOne.players.map { [$0[0] * magnifier, $0[1] * magnifier, $0[2] * magnifier] })

  return StepTwoResult(t: pt.t, x: Double(pt.x) / 1000.0, y: Double(pt.y) / 1000.0)
}

struct PositionAndTime: Equatable {
  let t: Double
  let x: Int
  let y: Int
}

struct StepOneResult: Equatable {
  let x: Int
  let y: Int
  let players: [[Int]]
}

struct StepTwoResult: Equatable {
  let t: Double
  let x: Double
  let y: Double
}
