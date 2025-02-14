/*
https://leetcode.com/problems/valid-sudoku/
*/

class Solution {
    func isValidSudoku(_ board: [[Character]]) -> Bool {
        areValidRows(board) && areValidColumns(board) && areValidSubboxes(board)
    }

    func areValidRows(_ board: [[Character]]) -> Bool {
        board.allSatisfy { isValid($0) }
    }

    func areValidColumns(_ board: [[Character]]) -> Bool {
        let n = board.count

        for i in 0..<n {
            var array: [Character] = Array(repeating: ".", count: n)

            for j in 0..<n {
                array[j] = board[j][i]
            }

            if !isValid(array) {
                return false
            }
        }

        return true
    }

    func areValidSubboxes(_ board: [[Character]]) -> Bool {
        for i in 0..<3 {
            let xRange = range(i)

            for j in 0..<3 {
                let yRange = range(j)
                var array: [Character] = []

                for a in xRange {
                    for b in yRange {
                        array.append(board[a][b])
                    }
                }

                if !isValid(array) {
                    return false
                }
            }
        }
        return true
    }

    func range(_ i: Int) -> Range<Int> {
        (i * 3)..<((i + 1) * 3)
    }

    func isValid(_ array: [Character]) -> Bool {
        let filtered = array.filter { $0 != "." }

        return filtered.count == Set(filtered).count
    }
}
