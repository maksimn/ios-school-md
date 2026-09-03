/*
Given an integer x, return true if x is palindrome integer.

An integer is a palindrome when it reads the same backward as forward.

For example, 121 is a palindrome while 123 is not.
*/
class Solution {
    func isPalindrome(_ x: Int) -> Bool {
        if x < 0 { 
            return false 
        }
        
        let order = String(x).count
        
        var i = 0
        var j = order - 1
        
        while i < j {
            let a = digitAt(i, x)
            let b = digitAt(j, x)
            
            if a != b {
                return false
            }
            
            i += 1
            j -= 1
        }
        
        return true
    }
    
    func digitAt(_ pos: Int, _ x: Int) -> Int {
        if pos == 0 {
            return x % 10
        }
        
        let d1 = pow(10, pos + 1)
        let d2 = pow(10, pos)
        
        return ((x % d1) - (x % d2)) / d2
    }
    
    func pow(_ a: Int, _ n: Int) -> Int {
        var result = 1
        
        for _ in 0..<n {
            result *= a
        }
        
        return result
    }
}

/*
Success
Details 
Runtime: 45 ms, faster than 80.41% of Swift online submissions for Palindrome Number.
Memory Usage: 14 MB, less than 54.81% of Swift online submissions for Palindrome Number.
*/
