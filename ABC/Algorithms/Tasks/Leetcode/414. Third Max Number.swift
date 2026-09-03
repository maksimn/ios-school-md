/*
Given an integer array nums, return the third distinct maximum number in this array. If the third maximum does not exist, return the maximum number.
*/

class Solution {
    func thirdMax(_ nums: [Int]) -> Int {
        var arr = [nums[0], Int.min, Int.min]

        for i in 1..<nums.count {
            if nums[i] > arr[0] {
                let t1 = arr[0]
                let t2 = arr[1]

                arr[0] = nums[i]
                arr[1] = t1
                arr[2] = t2
            } else if nums[i] > arr[1] && nums[i] < arr[0] {
                arr[2] = arr[1]
                arr[1] = nums[i]
            } else if nums[i] > arr[2] && nums[i] < arr[1] {
                arr[2] = nums[i]
            }
        }

        return arr[2] > Int.min ? arr[2] : arr[0]
    }
}
