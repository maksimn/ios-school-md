/*
https://leetcode.com/problems/count-special-quadruplets/
*/

class Solution {
    func countQuadruplets(_ nums: [Int]) -> Int {
        let n = nums.count
        var counter = 0
        var dict: [Int: Int] = [:]

        for c in (2..<n).reversed() {
            for b in (1..<c).reversed() {
                for a in (0..<b).reversed() {
                    counter += dict[nums[a] + nums[b] + nums[c]] ?? 0
                }
            }

             dict[nums[c]] = (dict[nums[c]] ?? 0) + 1
        }

        return counter
    }
}
