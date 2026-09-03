/*
https://leetcode.com/problems/longest-substring-without-repeating-characters/
*/

class Solution {
    func lengthOfLongestSubstring(_ s: String) -> Int {
        let s = Array(s)
        let n = s.count

        guard n > 0 else { return 0 }

        var set = Set<Character>()
        var maxLen = 0
        var i = 0
        var j = 0

        while i < n && i + maxLen <= n {
            j = findIndexOfRepeatingChar(s, j, &set)

            maxLen = max(maxLen, j - i)
            set.remove(s[i])
            i += 1
        }

        return maxLen
    }

    func findIndexOfRepeatingChar(
        _ s: [Character], _ i: Int, _ set: inout Set<Character>) -> Int {
        var j = i
        let n = s.count

        while j < n {
            if set.contains(s[j]) {
                return j
            } else {
                set.insert(s[j])
            }

            j += 1
        }

        return j
    }
}
