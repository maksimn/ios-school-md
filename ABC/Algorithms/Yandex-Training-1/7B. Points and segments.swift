/*
https://contest.yandex.ru/contest/27883/problems/B/
*/

let comps = (readLine() ?? "").split(separator: " ").map { String($0) }
let N = Int(comps[0]) ?? 0
let M = Int(comps[1]) ?? 0

var events: [Event] = []

for _ in 0..<N {
  let comps = (readLine() ?? "").split(separator: " ").map { String($0) }
  let b = Int(comps[0]) ?? 0
  let e = Int(comps[1]) ?? 0

  events.append(Event(t: min(b, e), type: -1))
  events.append(Event(t: max(b, e), type: 1))
}

let nums = (readLine() ?? "").split(separator: " ").map { Int($0) ?? 0 }

nums.forEach { events.append(Event(t: $0, type: 0)) }

struct Event: Comparable {
  let t: Int
  let type: Int

  static func <(lhs: Event, rhs: Event) -> Bool {
    (lhs.t == rhs.t && lhs.type < rhs.type) || lhs.t < rhs.t
  }
}

print(solve(events).map({ String($0) }).joined(separator: " "))

func solve(_ events: [Event]) -> [Int] {
  let times = events.filter({ $0.type == 0 }).map { $0.t }
  let events = events.sorted()
  var users = 0
  var dict: [Int: Int] = [:]
  var result: [Int] = []

  for event in events {
    if event.type == -1 {
      users += 1
    } else if event.type == 1 {
      users -= 1
    } else {
      dict[event.t] = users
    }
  }

  for t in times {
    result.append(dict[t] ?? 0)
  }

  return result
}
