/*
https://leetcode.com/problems/add-binary/
*/

class Solution {
    func addBinary(_ a: String, _ b: String) -> String {
        let c = a.count >= b.count ? Array(a.reversed()) : Array(b.reversed())
        let d = a.count >= b.count ? Array(b.reversed()) : Array(a.reversed())
        let n = c.count
        let k = d.count
        var result: [Character] = []
        var toNext = 0

        for i in 0..<k {
            let x = c[i]
            let y = d[i]

            if x == "1" && y == "1" && toNext == 1 {
                result.append("1")
            } else if x == "1" && y == "1" && toNext == 0 {
                result.append("0")
                toNext = 1
            } else if (x == "1" || y == "1") && toNext == 1 {
                result.append("0")
            } else if (x == "1" || y == "1") && toNext == 0 {
                result.append("1")
            } else if toNext == 1 {
                result.append("1")
                toNext = 0
            } else {
                result.append("0")
            }
        }

        for i in k..<n {
            if c[i] == "1" && toNext == 1 {
                result.append("0")
            } else if c[i] == "1" && toNext == 0 {
                result.append("1")
            } else if c[i] == "0" && toNext == 1 {
                result.append("1")
                toNext = 0
            } else {
                result.append("0")
            }
        }

        if toNext == 1 {
            result.append("1")
        }

        return String(result.reversed())
    }
}
