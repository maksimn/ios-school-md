/*
https://contest.yandex.ru/contest/27883/problems/A/
*/

let comps = (readLine() ?? "").split(separator: " ").map { String($0) }
let N = Int(comps[0]) ?? 0
let M = Int(comps[1]) ?? 0

var events: [Event] = []

for _ in 0..<M {
  let comps = (readLine() ?? "").split(separator: " ").map { String($0) }
  let b = Int(comps[0]) ?? 0
  let e = Int(comps[1]) ?? 0

  events.append(Event(x: b, type: -1))
  events.append(Event(x: e, type: 1))
}

struct Event: Comparable {
  let x: Int
  let type: Int

  static func <(lhs: Event, rhs: Event) -> Bool {
    return (lhs.x == rhs.x && lhs.type < rhs.type) || lhs.x < rhs.x
  }
}

print(countUnobservedStudents(events, N))

func countUnobservedStudents(_ events: [Event], _ N: Int) -> Int {
  let events = events.sorted()
  var xopen = -1 // координата открытия наблюдения
  var current = 0 // текущее количество наблюдающих преподов
  var sum = 0 // текущее количество студентов под наблюдением

  for event in events {
    if event.type == -1 {
      if xopen == -1 {
        xopen = event.x
      }

      current += 1
    } else {
      current -= 1

      if current == 0 {
        sum += event.x - xopen + 1
        xopen = -1
      }
    }
  }

  return N - sum
}
