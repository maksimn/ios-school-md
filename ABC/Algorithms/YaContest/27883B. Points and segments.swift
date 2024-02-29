/*
https://contest.yandex.ru/contest/27883/problems/B
*/

typealias Dict = [Int: [Int]]

struct Event {
  let pos: Int
  let opened: Int
  let opens: Int
  let close: Int
}

struct WEvent {
  let event: Event
  let end: Int
}

var dict: Dict = [:]

let tuple = readIntPair()
let n = tuple.0
let m = tuple.1

for _ in 0..<n {
  let tuple = readIntPair()
  let a = min(tuple.0, tuple.1)
  let b = max(tuple.0, tuple.1)

  if dict[a] != nil {
    dict[a]?.append(1)
  } else {
    dict[a] = [1]
  }

  if dict[b] != nil {
    dict[b]?.append(-1)
  } else {
    dict[b] = [-1]
  }
}

let wevents = weventsFromEvents(eventsFromDict(dict))
let line = readLine() ?? ""
let points = line.split(separator: " ").map { Int(String($0)) ?? 0 }

for p in points {
  print(numberOfSegments(p), terminator: " ")
}

print()

func eventsFromDict(_ dict: Dict) -> [Event] {
  var num = 0
  let keys = dict.keys.sorted()
  var events = Array(
    repeating: Event(pos: 0, opened: 0, opens: 0, close: 0), count: keys.count)

  for i in 0..<keys.count {
    let pos = keys[i]
    let arr = dict[pos] ?? []
    let add = arr.filter { $0 == 1 }.count
    let sub = arr.filter { $0 == -1 }.count

    events[i] = Event(pos: pos, opened: num, opens: add, close: sub)

    num += (add - sub)
  }

  return events
}

func weventsFromEvents(_ events: [Event]) -> [WEvent] {
  let n = events.count
  var wevents: [WEvent] = []

  for i in 0..<(n - 1) {
      wevents.append(.init(event: events[i], end: events[i + 1].pos - 1))
  }

  wevents.append(.init(event: events[n - 1], end: events[n - 1].pos))

  return wevents
}

func numberOfSegments(_ p: Int) -> Int {
  guard let e = binSearch(p, wevents) else { return 0 }

  return p == e.pos ? e.opened + e.opens : e.opened + e.opens - e.close
}

func binSearch(_ p: Int, _ wevents: [WEvent]) -> Event? {
  let n = wevents.count
  var l = 0, h = n - 1

  while l <= h {
    let m = (l + h) / 2
    let we = wevents[m]

    if p >= we.event.pos && p <= we.end {
      return we.event
    } else if p > we.end {
      l = m + 1
    } else {
      h = m - 1
    }
  }

  return nil
}

func readIntPair() -> (Int, Int) {
  let line = readLine() ?? ""
  let comps = line.split(separator: " ").map { String($0) }
  let n = Int(comps[0]) ?? 0
  let m = Int(comps[1]) ?? 0

  return (n, m)
}
