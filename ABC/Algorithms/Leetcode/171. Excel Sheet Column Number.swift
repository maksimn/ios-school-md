/*
https://leetcode.com/problems/excel-sheet-column-number/
*/

class Solution {

    func titleToNumber(_ columnTitle: String) -> Int {
        let chars = Array(columnTitle.reversed())
        var m = 1
        var result = 0
        let offset = Character("A").asciiValue! - 1
        
        for ch in chars {
            let num = Int(ch.asciiValue! - offset)

            result += num * m
            m *= 26
        }

        return result
    }
}