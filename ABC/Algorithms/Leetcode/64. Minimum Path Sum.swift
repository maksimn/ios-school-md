/*
https://leetcode.com/problems/minimum-path-sum/
*/

class Solution {
    var cache: [[Int]] = []

    func minPathSum(_ grid: [[Int]]) -> Int {
        let m = grid.count
        let n = grid[0].count

        cache = Array(repeating: Array(repeating: Int.max, count: n), count: m)

        return minPathSum(grid, 0, 0)
    }

    func minPathSum(_ grid: [[Int]], _ i: Int, _ j: Int) -> Int {
        if cache[i][j] != Int.max {
            return cache[i][j]
        }

        let m = grid.count
        let n = grid[0].count
        var result = Int.max

        if i + 1 < m && j + 1 < n {
            let sum1 = grid[i][j] + minPathSum(grid, i + 1, j)
            let sum2 = grid[i][j] + minPathSum(grid, i, j + 1)

            result = min(sum1, sum2)
        } else if i + 1 < m && j == n - 1 {
            result = grid[i][j] + minPathSum(grid, i + 1, j)
        } else if i == m - 1 && j + 1 < n {
            result = grid[i][j] + minPathSum(grid, i, j + 1)
        } else {
            result = grid[m - 1][n - 1]
        }

        cache[i][j] = result

        return result
    }
}
