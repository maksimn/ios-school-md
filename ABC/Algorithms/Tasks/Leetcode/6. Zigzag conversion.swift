/*
https://leetcode.com/problems/zigzag-conversion/
*/

class Solution {
    func convert(_ s: String, _ numRows: Int) -> String {
        guard numRows > 1 else { return s }
        let chars = Array(s)
        let n = chars.count
        var zigzag: [Character] = Array(repeating: "0", count: n)
        var j = 0

        for r in 0..<numRows {
            var i = r

            while i < n {
                zigzag[j] = chars[i]
                j += 1

                if r != 0 && r != numRows - 1 {
                    let i1 = i + 2 * (numRows - r - 1)

                    if i1 < n {
                        zigzag[j] = chars[i1]
                        j += 1
                    }
                }

                i += 2 * numRows - 2
            }
        }

        return String(zigzag)
    }
}
