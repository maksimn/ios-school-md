/*
https://leetcode.com/problems/combination-sum/
*/

class Solution {
    func combinationSum(_ candidates: [Int], _ target: Int) -> [[Int]] {
        let nums = candidates.sorted()
        let limits = nums.map({ target / $0 }).filter { $0 > 0 }
        var result: [[Int]] = []

        findCombinations(&result, 0, limits, [], nums, target)

        return result
    }

    func findCombinations(_ result: inout [[Int]], _ sum0: Int, _ limits: [Int],
                          _ multipliers: [Int], _ nums: [Int], _ target: Int) {
        if sum0 == target {
            var array: [Int] = []

            for i in 0..<multipliers.count {
                array += Array(repeating: nums[i], count: multipliers[i])
            }

            result.append(array)
            return
        }

        if limits.isEmpty { return }

        if limits.count == 1 {
            for i in 0...limits[0] {
                if sum0 + i * nums[multipliers.count] == target {
                    var array: [Int] = []

                    for i in 0..<multipliers.count {
                        array += Array(repeating: nums[i], count: multipliers[i])
                    }

                    if i > 0 {
                        array += Array(repeating: nums[multipliers.count], count: i)
                    }
                    result.append(array)
                }
            }
        } else {
            let n = limits.count
            let suffix: [Int] = limits.suffix(n - 1)

            for i in 0...limits[0] {
                let s = sum0 + i * nums[multipliers.count]
                var multipliers = multipliers

                multipliers.append(i)

                if s <= target {
                    findCombinations(&result, s, suffix, multipliers, nums, target)
                }
            }
        }
    }
}
