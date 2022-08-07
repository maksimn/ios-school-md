/*
100. Same Tree

Given the roots of two binary trees p and q, write a function to check if they are the same or not.

Two binary trees are considered the same if they are structurally identical, and the nodes have the same value.
*/

class Solution {
    func isSameTree(_ p: TreeNode?, _ q: TreeNode?) -> Bool {
        if countTreeSize(p) != countTreeSize(q) { return false }
        guard let p = p, let q = q, p.val == q.val else {
            return (p == nil) && (q == nil)
        }
        var queueOne = [p]
        var queueTwo = [q]

        while !queueOne.isEmpty {
            let n1 = queueOne.removeFirst()
            let n2 = queueTwo.removeFirst()

            if n1.val != n2.val { return false }
            if process(n1.left, n2.left, &queueOne, &queueTwo) { return false }
            if process(n1.right, n2.right, &queueOne, &queueTwo) { return false }
        }

        return true
    }

    func process(_ n1: TreeNode?,
                 _ n2: TreeNode?,
                 _ queueOne: inout [TreeNode],
                 _ queueTwo: inout [TreeNode]) -> Bool {
        guard let n1 = n1, let n2 = n2 else {
            return !((n1 == nil) && (n2 == nil))
        }

        if n1.val != n2.val { return true }

        queueOne.append(n1)
        queueTwo.append(n2)

        return false
    }

    func countTreeSize(_ p: TreeNode?) -> Int {
        var n = 0
        guard let p = p else { return n }
        var queue: [TreeNode] = []

        countNode(p, &queue, &n)

        while queue.count > 0 {
            let node = queue.removeFirst()
            countNode(node.left, &queue, &n)
            countNode(node.right, &queue, &n)
        }

        return n
    }

    func countNode(_ node: TreeNode?, _ queue: inout [TreeNode], _ n: inout Int) {
        guard let node = node else { return }

        queue.append(node)
        n += 1
    }
}
