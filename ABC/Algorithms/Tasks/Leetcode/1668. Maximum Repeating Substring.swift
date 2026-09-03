/*
https://leetcode.com/problems/maximum-repeating-substring/
*/

class Solution {

    var cache: [Int: Int] = [:]

    func maxRepeating(_ sequence: String, _ word: String) -> Int {
        let s = Array(sequence)
        let w = Array(word)
        let occurences = findAllOccurences(of: w, in: s)
        var result = 0

        for i in occurences {
            result = max(result, maxRepeating(s, w, i))
        }

        return result
    }

    func maxRepeating(_ s: [Character], _ w: [Character], _ i: Int) -> Int {
        if let result = cache[i] { return result }

        let k = w.count
        var ans = 1

        if Self.startsWithWordFromPosition(s, w, i + k) {
            ans = 1 + maxRepeating(s, w, i + k)
        }

        cache[i] = ans

        return ans
    }

    func findAllOccurences(of word: [Character], in s: [Character]) -> [Int] {
        var result: [Int] = []

        for i in 0..<s.count where Self.startsWithWordFromPosition(s, word, i) {
            result.append(i)
        }

        return result
    }

    static func startsWithWordFromPosition(
        _ s: [Character], _ word: [Character], _ pos: Int) -> Bool {
        let n = s.count
        let k = word.count

        guard pos + k <= n else { return false }

        for i in 0..<k {
            if s[pos + i] != word[i] { return false }
        }

        return true
    }
}
