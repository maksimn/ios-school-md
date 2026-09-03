/*
https://contest.yandex.ru/contest/59542/problems/H
*/

let _line = readLine() ?? ""
let _N = Int(_line) ?? 0
var _pairs = Array(repeating: (0, 0), count: _N)

for i in 0..<_N {
  let line = readLine() ?? ""
  let nums = line.split(separator: " ").map { Int(String($0)) ?? 0 }

  _pairs[i] = (nums[0], nums[1])
}

let answer = solve(_pairs)

print(answer.minExpense)
print(answer.partyNumber)

for v in answer.votes {
  print(v, terminator: " ")
}

print()

func solve(_ pairs: [(Int, Int)]) -> Answer {
  let emptyAnswer = Answer(minExpense: 0, partyNumber: 0, votes: [])
  let parties = pairs.enumerated().map { (ind, pair) in Party(id: ind, bribe: pair.1, voters: pair.0) }

  guard parties.count > 1 else { return Answer(minExpense: pairs[0].1, partyNumber: 1, votes: [pairs[0].0]) }

  let sortedParties = parties.sorted(by: { $0.voters > $1.voters })
  let prefixSum = findPrefixSum(sortedParties)

  let expenses = parties.map { findExpense($0, sortedParties, prefixSum) }
  guard let minExpense = expenses.min() else { return emptyAnswer }
  guard let ind = expenses.firstIndex(of: minExpense) else { return emptyAnswer }
  let finalVotes = findFinalVotes(sortedParties, parties[ind], minExpense)

  return Answer(
    minExpense: minExpense,
    partyNumber: ind + 1,
    votes: finalVotes
  )
}

func findPrefixSum(_ sortedPartes: [Party]) -> [Int] {
  var nums = Array(repeating: 0, count: sortedPartes.count)
  var sum = 0

  for i in 0..<sortedPartes.count {
    sum += sortedPartes[i].voters
    nums[i] = sum
  }

  return nums
}

func findFinalVotes(_ sortedPartes: [Party], _ party: Party, _ minExpense: Int) -> [Int] {
  let n = sortedPartes.count
  var sortedPartes = sortedPartes
  let maxVotes = party.voters + minExpense - party.bribe
  let boughtVotes = maxVotes - party.voters
  var cutVotes = 0

  for i in 0..<n {
    if sortedPartes[i].id != party.id && sortedPartes[i].voters >= maxVotes  {
      cutVotes += (sortedPartes[i].voters - maxVotes + 1)

      sortedPartes[i] = Party(id: sortedPartes[i].id, bribe: sortedPartes[i].bribe, voters: maxVotes - 1)
    } else if sortedPartes[i].id == party.id {
      sortedPartes[i] = Party(id: party.id, bribe: party.bribe, voters: maxVotes)
    }
  }

  if cutVotes < boughtVotes {
    let sp = sortedPartes[0]

    if sp.id != party.id {
      sortedPartes[0] = Party(id: sp.id, bribe: sp.bribe, voters: sp.voters - (boughtVotes - cutVotes))
    } else {
      let sp = sortedPartes[1]

      sortedPartes[1] = Party(id: sp.id, bribe: sp.bribe, voters: sp.voters - (boughtVotes - cutVotes))
    }
  }

  var parties = Array(repeating: Party(id: 0, bribe: 0, voters: 0), count: n)

  for i in 0..<n {
    let sp = sortedPartes[i]

    parties[sp.id] = sp
  }

  return parties.map { $0.voters }
}

func findExpense(_ party: Party, _ sortedParties: [Party], _ prefixSum: [Int]) -> Int {
  if party.bribe == -1 {
    return Int.max
  }

  var l = party.voters
  var h = sortedParties[0].voters + 1

  while l < h {
    let m = (l + h) / 2
    let addVotes = findAddVotes(m, sortedParties, prefixSum, party)

    if party.voters + addVotes <= m {
      h = m
    } else {
      l = m + 1
    }
  }

  return party.bribe + (l - party.voters)
}

func findAddVotes(_ maxVotes: Int, _ sortedParties: [Party], _ prefixSum: [Int], _ party: Party) -> Int {
  var l = 0
  var h = sortedParties.count - 1

  while l < h {
    let m = (l + h + 1) / 2

    if sortedParties[m].voters > (maxVotes - 1) {
      l = m
    } else {
      h = m - 1
    }
  }

  let add = prefixSum[l] - (l + 1) * (maxVotes - 1)
  var correction = 0

  if maxVotes <= party.voters {
    correction = party.voters - maxVotes + 1
  }

  return add - correction
}

struct Answer: Equatable {
  let minExpense: Int
  let partyNumber: Int
  let votes: [Int]
}

struct Party: Equatable {
  let id: Int
  let bribe: Int
  let voters: Int
}
