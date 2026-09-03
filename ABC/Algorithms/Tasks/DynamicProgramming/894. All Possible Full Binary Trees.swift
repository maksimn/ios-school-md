/*
Given an integer n, return a list of all possible full binary trees with n nodes. Each node of each tree in the answer must have Node.val == 0.

Each element of the answer is the root node of one possible tree. You may return the final list of trees in any order.

A full binary tree is a binary tree where each node has exactly 0 or 2 children.
*/

/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     public var val: Int
 *     public var left: TreeNode?
 *     public var right: TreeNode?
 *     public init() { self.val = 0; self.left = nil; self.right = nil; }
 *     public init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
 *     public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
 *         self.val = val
 *         self.left = left
 *         self.right = right
 *     }
 * }
 */

// Решение с Leetcode

class Solution {
    var cache: [Int: [TreeNode?]] = [:]

    func allPossibleFBT(_ n: Int) -> [TreeNode?] {
        if n % 2 == 0 {
            return []
        } else if n == 1 {
            return [TreeNode()]
        } else if let result = cache[n] {
            return result
        }

        var res: [TreeNode?] = []

        for i in stride(from: 1, to: n, by: 2) {
            let left = allPossibleFBT(i)
            let right = allPossibleFBT(n - i - 1)

            for l in left {
                for r in right {
                    let root = TreeNode(0, l, r)

                    res.append(root)
                }
            }
        }

        cache[n] = res

        return res
    }
}