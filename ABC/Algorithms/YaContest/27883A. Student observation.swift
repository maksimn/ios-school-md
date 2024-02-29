/*
https://contest.yandex.ru/contest/27883/problems/A
*/

var line = readLine() ?? ""
let comps = line.split(separator: " ").map { String($0) }
let N = Int(comps[0]) ?? 0
let M = Int(comps[1]) ?? 0

var dict: [Int: Int] = [:]

for _ in 0..<M {
  line = readLine() ?? ""
  let comps = line.split(separator: " ").map { String($0) }
  let b = Int(comps[0]) ?? 0
  let e = Int(comps[1]) ?? 0

  if let val = dict[b] {
    dict[b] = val + 1
  } else {
    dict[b] = 1
  }

  if let val = dict[e] {
    dict[e] = val - 1
  } else {
    dict[e] = -1
  }
}

let keys = dict.keys.sorted()

var opener = -1
var sum = 0
var count = 0

for p in keys {
  sum += dict[p] ?? 0

  if sum > 0 && opener < 0 {
    opener = p
  } else if sum == 0 && opener >= 0 {
    count += (p - opener + 1)
    opener = -1
  } else if sum == 0 && opener < 0 {
    count += 1
  }
}

print(N - count)
