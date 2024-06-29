/*
94. Binary Tree Inorder Traversal

Given the root of a binary tree, return the inorder traversal of its nodes' values.
*/

class Solution {
    func inorderTraversal(_ root: TreeNode?) -> [Int] {
        var result: [Int] = []

        if let root = root {
            visit(root, &result)
        }
        
        return result
    }
    
    func visit(_ node: TreeNode?, _ result: inout [Int]) {
        if let node = node {
            visit(node.left, &result)
            result.append(node.val)
            visit(node.right, &result)
        }
    }
}
