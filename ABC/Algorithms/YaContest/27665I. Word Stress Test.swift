/*
https://contest.yandex.ru/contest/27665/problems/I
*/

typealias Dict = [String: [String]]

var text = readLine() ?? ""
let N = Int(text) ?? 0
var dict: Dict = [:]

for _ in 0..<N {
  let line = readLine() ?? ""

  if dict[line.lowercased()] != nil {
    dict[line.lowercased()]?.append(line)
  } else {
    dict[line.lowercased()] = [line]
  }
}

text = readLine() ?? ""

print(countErrors(text, dict))

func countErrors(_ text: String, _ dict: Dict) -> Int {
  let words = text.split(separator: " ").map { String($0) }
  var count = 0

  for word in words {
    count += countErrorsInWord(word, dict)
  }

  return count
}

func countErrorsInWord(_ word: String, _ dict: Dict) -> Int {
  if let stresses = dict[word.lowercased()] {
    return stresses.contains(word) ? 0 : 1
  } else if word.filter({ $0.isUppercase }).count == 1 {
    return 0
  } else {
    return 1
  }
}
