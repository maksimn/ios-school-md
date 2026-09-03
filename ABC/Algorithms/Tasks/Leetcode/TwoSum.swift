/*
Given an array of integers nums and an integer target, return indices of the two numbers 
such that they add up to target.

You may assume that each input would have exactly one solution, and you may not use 
the same element twice.

You can return the answer in any order.
*/
class Solution {
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        var dict: [Int: (Int, Int?)] = [:]

        for i in 0..<nums.count {
            let x = nums[i]

            if let tuple = dict[x] {
                if tuple.1 == nil {
                    dict[x] = (tuple.0, i)
                }
            } else {
                dict[x] = (i, nil)
            }
        }

        for i in 0..<nums.count {
            let a = nums[i]
            let b = target - a
            
            if let tuple = dict[b] {
                if a == b, let i2 = tuple.1 {
                    return [i, i2]
                } else if a != b {
                    return [i, tuple.0]
                }
            }
        }
        return [-2, -2]
    }
}

/*
RESULT:

Runtime: 46 ms, faster than 92.35% of Swift online submissions for Two Sum.
Memory Usage: 14.9 MB, less than 8.08% of Swift online submissions for Two Sum.
*/