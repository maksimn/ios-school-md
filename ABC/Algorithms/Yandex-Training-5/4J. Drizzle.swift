/*
https://contest.yandex.ru/contest/59542/problems/J
*/

import Foundation

let line = readLine() ?? ""
let comps = line.split(separator: " ").map { String($0) }
let _N = Int(comps[0]) ?? 0
let _H = Double(comps[1]) ?? 0.0
var _points = Array(repeating: (0, 0), count: _N + 1)

for i in 0..<(_N + 1) {
  let line = readLine() ?? ""
  let nums = line.split(separator: " ").map { Int(String($0)) ?? 0 }

  _points[i] = (nums[0], nums[1])
}

let solution = Solution()

print(solution.solve(_points, _H))

class Solution {

  var overflows: [Int: Double] = [:]
  var allPoints: [Point] = []
  var H = 0.0

  func solve(_ points: [(Int, Int)], _ H: Double) -> Double {
    solve(points.map { Point(x: Double($0.0), y: Double($0.1)) }, H)
  }

  func solve(_ points: [Point], _ H: Double) -> Double {
    self.H = H
    allPoints = points

    let ymax = points.ymax
    let xL = points.first?.x ?? 0.0
    let xR = points.last?.x ?? 0.0
    let V = H * abs(xL - xR)

    if isLevelOfWaterHigherOrEqualTo(ymax, points, V: V) {
      let h = findDepthFor(points, V: V)

      return h
    }

    let region0 = Region(points: points, ymax: ymax)
    let subregions = split(ymax, region0)
    let result = solveFor(subregions)

    return result
  }

  func solveFor(_ regions: [Region]) -> Double {
    var hMax = 0.0

    for region in regions {
      let V = findWaterVolumeFor(region)
      let ymax2 = findYLowerThanYmax(region.points, region.ymax)

      if isLevelOfWaterHigherOrEqualTo(ymax2, region.points, V: V) {
        let h = findDepthFor(region.points, V: V)

        hMax = max(hMax, h)
        continue
      }

      let subregions = split(ymax2, region)
      let h = solveFor(subregions)

      hMax = max(hMax, h)
    }

    return hMax
  }

  func distributeWaterVolume(region: Region, subregions: [Region]) {
    let x0 = region.points.first?.x ?? 0.0
    let xN = region.points.last?.x ?? 0.0
    let V0 = (xN - x0) * H
    let VL = overflows[Int(x0.rounded(.toNearestOrEven))] ?? 0.0
    let VR = overflows[Int(xN.rounded(.toNearestOrEven)) - 1] ?? 0.0

    if subregions.count == 1 {
      let sr = subregions[0]
      let x1 = sr.points.first?.x ?? 0.0
      let x2 = sr.points.last?.x ?? 0.0
      let v0 = (x2 - x1) * H
      let vL = VL + V0 - v0

      overflows[Int(x1.rounded(.toNearestOrEven))] = vL
      overflows[Int(x2.rounded(.toNearestOrEven)) - 1] = VR
    } else if subregions.count == 2 {
      let sr1 = subregions[0]
      let sr2 = subregions[1]
      let xi = sr1.points.last?.x ?? 0.0
      let V1 = V0 * (xi - x0) / (xN - x0)
      let V2 = V0 * (xN - xi) / (xN - x0)
      let x1 = sr1.points.first?.x ?? 0.0
      let x2 = sr2.points.last?.x ?? 0.0
      let u0 = (xi - x1) * H
      let v0 = (x2 - xi) * H
      var uL = VL + V1 - u0
      var vR = VR + V2 - v0
      let av1 = findAvailableVolumeBelowY(sr1.points, sr1.ymax)
      let av2 = findAvailableVolumeBelowY(sr2.points, sr2.ymax)

      if u0 + uL > av1 {
        let du = u0 + uL - av1

        uL -= du
        overflows[Int(xi.rounded(.toNearestOrEven))] = du
      } else if v0 + vR > av2 {
        let dv = v0 + vR - av2

        vR -= dv
        overflows[Int(xi.rounded(.toNearestOrEven)) - 1] = dv
      }

      overflows[Int(x1.rounded(.toNearestOrEven))] = uL
      overflows[Int(x2.rounded(.toNearestOrEven)) - 1] = vR
    }
  }

  func findYLowerThanYmax(_ points: [Point], _ ymax: Double) -> Double {
    var localYmax = points.ymin

    for point in points where point.y > localYmax && point.y < ymax {
      localYmax = point.y
    }

    return localYmax
  }

  func findWaterVolumeFor(_ region: Region) -> Double {
    let x1 = region.points.first?.x ?? 0.0
    let x2 = region.points.last?.x ?? 0.0
    var dV = 0.0

    if let dV1 = overflows[Int(x1.rounded(.toNearestOrEven))] {
      dV += dV1
    }

    if let dV1 = overflows[Int(x2.rounded(.toNearestOrEven)) - 1] {
      dV += dV1
    }

    let V = H * (x2 - x1) + dV

    return V
  }

  func isLevelOfWaterHigherOrEqualTo(_ y: Double, _ points: [Point], V: Double) -> Bool {
    let volume = findAvailableVolumeBelowY(points, y)

    return V >= volume
  }

  func findDepthFor(_ points: [Point], V: Double) -> Double {
    let ymin = points.ymin
    var l = ymin
    let den = (points.last?.x ?? 1.0) - (points.first?.x ?? 0.0)
    var h = points.ymax + V / den

    while true {
      let m = (l + h) / 2
      let fx = findAvailableVolumeBelowY(points, m) - V

      if fx > 0 {
        h = m
      } else if fx == 0 {
        l = m
        break
      } else {
        l = m
      }

      if abs(h - l) < 1e-4 {
        l = (l + h) / 2
        break
      }
    }

    return l - ymin
  }

  func findAvailableVolumeBelowY(_ points: [Point], _ y: Double) -> Double {
    var sum = 0.0
    let n = points.count

    for i in 0..<(n - 1) {
      sum += findVolumeForSegment(points[i], points[i + 1], y)
    }

    return sum
  }

  func findVolumeForSegment(_ a: Point, _ b: Point, _ y0: Double) -> Double {
    let x1 = Double(a.x), x2 = Double(b.x), y1 = Double(a.y), y2 = Double(b.y)
    let a = min(y1, y2)
    let b = max(y1, y2)

    if y1 > y0 && y2 > y0 {
      return 0.0
    } else if (y2 - y0) * (y1 - y0) < 0.0 {
      return 0.5 * (x2 - x1) * (y0 - a) * (y0 - a) / (b - a)
    } else {
      return (x2 - x1) * (y0 - b + 0.5 * abs(a - b))
    }
  }

  func split(_ y2: Double, _ region: Region) -> [Region] {
    let points = region.points
    let n = points.count

    guard n > 1 else { return [] }
    guard let ind = points.firstIndex(where: { $0.y == y2 }) else { return [] }

    let one = Array(points[0..<(ind + 1)])
    let two = Array(points[ind..<n])
    let i1 = findRegionStart(y2, one)
    let i2 = findRegionEnd(1, y2, two)
    let points1 = Array(one[i1..<one.count])
    let points2 = Array(two[0..<min(i2 + 1, two.count)])
    var subregions: [Region] = []

    if points1.count > 1 && points2.count > 1 {
      subregions = [Region(points: points1, ymax: y2), Region(points: points2, ymax: y2)]
    } else if points1.count > 1 {
      subregions = [Region(points: points1, ymax: y2)]
    } else if points2.count > 1 {
      subregions = [Region(points: points2, ymax: y2)]
    }

    distributeWaterVolume(region: region, subregions: subregions)

    return subregions
  }

  func findRegionStart(_ y: Double, _ points: [Point]) -> Int {
    for j in 0..<points.count {
      if points[j].y < y {
        return j
      }

      if j + 1 < points.count && points[j + 1].y < y {
        return j
      }
    }

    return points.count
  }

  func findRegionEnd(_ i: Int, _ y: Double, _ points: [Point]) -> Int {
    for j in i..<points.count {
      if points[j].y >= y && j - 1 >= 0 && points[j - 1].y >= y {
        return j - 1
      }

      if points[j].y >= y {
        return j
      }
    }

    return points.count
  }
}

struct Point: Equatable {
  let x: Double
  let y: Double
}

struct Region: Equatable {
  let points: [Point]
  let ymax: Double
}

extension Array where Element == Point {

  var ymin: Double {
    self.min(by: { $0.y < $1.y })?.y ?? 0.0
  }

  var ymax: Double {
    self.max(by: { $0.y < $1.y })?.y ?? 0.0
  }
}
