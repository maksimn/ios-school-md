/*
https://contest.yandex.ru/contest/27665/problems/J
*/

var text = readLine() ?? ""
let comps = text.split(separator: " ").map { String($0) }
let keywordCount = Int(comps[0]) ?? 0
let isCaseSensitive = comps[1] == "yes" ? true : false
let isIdDigitStartable = comps[2] == "yes" ? true : false

var keywords = Set<String>()

for _ in 0..<keywordCount {
  text = readLine() ?? ""
  keywords.insert(text)
}

let keywordsLowercased = Set<String>(keywords.map { $0.lowercased() })

// [Идентификатор: (Кол-во появлений, Порядковый номер первого появления)]
typealias Dict = [String: (Int, Int)]

var dict: Dict = [:]

var order = 0

while let line = readLine() {
  getIds(line)
}

print(theMostFrequentKey(dict))

func getIds(_ str: String) {
  let chars = Array(str)
  let n = chars.count
  var i = 0, j = 0

  while i < n {
    let flag = isCharForId(chars[i])

    if flag {
      j = i

      while j < n {
        if isCharForId(chars[j]) {
          j += 1
        } else {
          break
        }
      }

      let substr = String(chars[i..<j])
      let candidate = isCaseSensitive ? substr : substr.lowercased()

      if predicate(candidate) {
        if let tuple = dict[candidate] {
          dict[candidate] = (tuple.0 + 1, tuple.1)
        } else {
          dict[candidate] = (1, order)
        }

        order += 1
      }

      i = j
    } else {
      i += 1
    }
  }
}

func theMostFrequentKey(_ dict: Dict) -> String {
  dict.map { $0 }
      .sorted(by: { (kv1, kv2) in
          if kv1.value.0 > kv2.value.0 {
              return true
          } else if kv1.value.0 == kv2.value.0 {
              return kv1.value.1 < kv2.value.1
          } else {
              return false
          }
      }).first?.key ?? ""
}

func predicate(_ str: String) -> Bool {
  switch (isCaseSensitive, isIdDigitStartable) {
  case (true, true):
    return caseSensitiveAndDigitStartable(str)

  case (true, false):
    return caseSensitiveAndNotDigitStartable(str)

  case (false, true):
    return caseInsensitiveAndDigitStartable(str)

  case (false, false):
    return caseInsensitiveAndNotDigitStartable(str)
  }
}

func caseSensitiveAndDigitStartable(_ str: String) -> Bool {
  if keywords.contains(str) {
    return false
  }

  return str.first(where: { !$0.isNumber }) != nil
}

func caseSensitiveAndNotDigitStartable(_ str: String) -> Bool {
  if let firstChar = str.first, firstChar.isNumber { return false }

  return caseSensitiveAndDigitStartable(str)
}

func caseInsensitiveAndDigitStartable(_ str: String) -> Bool {
  if keywordsLowercased.contains(str.lowercased()) {
    return false
  }

  return str.first(where: { !$0.isNumber }) != nil
}

func caseInsensitiveAndNotDigitStartable(_ str: String) -> Bool {
  if let firstChar = str.first, firstChar.isNumber { return false }

  return caseInsensitiveAndDigitStartable(str)
}

func isCharForId(_ ch: Character) -> Bool {
  ch.isLetter || ch.isNumber || ch == "_"
}
