/*
https://contest.yandex.ru/contest/27665/problems/H
*/

var count = 0

let text = readLine() ?? ""
let comps = text.split(separator: " ").map { String($0) }
let g = Int(comps[0]) ?? 0
let L = Int(comps[1]) ?? 0
let W = readLine() ?? ""
let S = readLine() ?? ""
let w = Array(W)
let s = Array(S)

let alphabetSize = 52

let wArray = stringToFrequencyArray(w)
var array = stringToFrequencyArray(Array(s.prefix(g)))
var diff = Array(repeating: 0, count: alphabetSize)

for i in 0..<alphabetSize {
  diff[i] = array[i] - wArray[i]
}

var areTheSame = diff.allSatisfy { $0 == 0 }

if areTheSame {
  count += 1
}

var pos = 1

while pos + g - 1 < L {
  let prev = s[pos - 1]
  let next = s[pos + g - 1]

  if prev == next && areTheSame {
    pos += 1
    count += 1
    continue
  }

  let prevInd = charToIndex(prev)
  let nextInd = charToIndex(next)

  diff[prevInd] -= 1
  diff[nextInd] += 1

  areTheSame = diff.allSatisfy { $0 == 0 }

  if areTheSame {
    count += 1
  }

  pos += 1
}

print(count)

func stringToFrequencyArray(_ str: [Character]) -> [Int] {
  var array = Array(repeating: 0, count: alphabetSize)

  str.forEach { ch in
    let ind = charToIndex(ch)

    array[ind] = array[ind] + 1
  }

  return array
}

func charToIndex(_ ch: Character) -> Int {
  guard let asciiCode = ch.asciiValue else { return -1 }
  let code = Int(asciiCode)

  if ch.isUppercase {
    return code - 65
  } else {
    return code - 71
  }
}
