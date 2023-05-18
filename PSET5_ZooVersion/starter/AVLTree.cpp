/*
 * Name: Marcus Lisman
 * Filename: AVLTree.cpp
 * Contains: Implementation of AVL Trees for CPSC 223
 * Part of: Homework assignment "AVL Trees" for CPSC 223
 */

#include <iostream>

#include "AVLTree.h"
#include "pretty_print.h"

using namespace std;

/*
 * Input: data (the value to store), multiplicity of the node, height of the
 *      node, left and right child pointers
 * Returns: avl tree node.
 * Does: creates a new node with values given as input parameter
 */
static Node *new_node(int data, int multiplicity, int height, Node *left, Node *right)
{
    Node *node = new Node();

    node->data = data;
    node->count = multiplicity;
    node->height = height;
    node->left = left;
    node->right = right;

    return node;
}

/*
 * Input: data (the value to store)
 * Returns: avl tree node.
 * Does: calls a helper function to create a new node with default
 *        values parameter
 */
static Node *new_node(int data)
{
    return new_node(data, 1, 0, NULL, NULL);
}

/********************************
 * BEGIN PUBLIC AVLTREE SECTION *
 ********************************/

/*
     * Input: N/A
     * Returns: N/A
     * Does: constructor for an AVL tree
     */
AVLTree::AVLTree()
{
    root = NULL;
}

/*
     * Input: source AVL tree
     * Returns: N/A
     * Does: acts as a copy constructor
     */
AVLTree::AVLTree(const AVLTree &source)
{
    root = pre_order_copy(source.root);
}

/*
     * Input: N/A
     * Returns: N/A
     * Does: destructor for the AVL tree
     */
AVLTree::~AVLTree()
{
    post_order_delete(root);
}

// assignment overload
AVLTree &AVLTree::operator=(const AVLTree &source)
{
    // check for self-assignment
    if(this == &source)
    {
        return *this;
    }

    // delete current tree if it exists
    post_order_delete(root);

    // use pre-order traversal to copy the tree
    root = pre_order_copy(source.root);

    // don't forget to "return *this"
    return *this;
}

int AVLTree::find_min() const
{
    return find_min(root)->data;
}

int AVLTree::find_max() const
{
    return find_max(root)->data;
}

bool AVLTree::contains(int value) const
{
    return contains(root, value);
}

void AVLTree::insert(int value)
{
    root = insert(root, value);
}

void AVLTree::remove(int value)
{
    root = remove(root, value);
}

int AVLTree::tree_height() const
{
    return tree_height(root);
}

int AVLTree::node_count() const
{
    return node_count(root);
}

int AVLTree::count_total() const
{
    return count_total(root);
}

void AVLTree::print_tree() const
{
    print_pretty(root, 1, 0, std::cout);
}

/*************************
 * BEGIN PRIVATE SECTION *
 *************************/

/*
     * Input: N/A
     * Returns: the minimum value in this
     * Does: Searches this for its minimum value, and returns it. Behavior
     *      is undefined if this is empty
     */
Node *AVLTree::find_min(Node *node) const
{
    if (node->left == nullptr) 
    {
        return node;
    }
    else 
    {
        return find_min(node->left);
    }
}

/*
     * Input: N/A
     * Returns: the maximum value in this
     * Does: Searches this for its maximum value, and returns it. Behavior
     *      is undefined if this is empty
     */
Node *AVLTree::find_max(Node *node) const
{
    if (node->right == nullptr) 
    {
        return node;
    }
    else
    {
        return find_max(node->right);
    }
}

/*
     * Input: int value - value to search for
     * Returns: true if there is a node in this with data = value, false
     *      otherwise
     * Does: searches the tree for value
     */
bool AVLTree::contains(Node *node, int value) const
{
    /* 
    * Conditions checked:
    * 1) if null, then value is not in tree
    * 2) if == value, then value exists and return true
    * 3) if value less than the current node, go left (AVL structure has
    *       lesser values on left side, so go left to search)
    * 4) if value more than current, go right (AVL structure  has
    *       greater values on right side, so go right)
    *  */
    if (node == nullptr) 
     {
        return false;
    } 
    else if (node->data == value) 
    {
        return true;
    } 
    else if (value < node->data) 
    {
        return contains(node->left, value);
    } 
    else 
    {
        return contains(node->right, value);
    }
}

/*
     * Input: int value - value to insert
     * Returns: N/A
     * Does: Inserts value into this, either by creating a new node or, if
     *      value is already in this, by incrementing that node's count
     */
Node *AVLTree::insert(Node *node, int value)
{
    /* BST insertion start */
    if (node == nullptr)
    {
        return new_node(value);
    }
    else if (value < node->data)
    {
        node->left = insert(node->left, value);
    }
    else if (value > node->data)
    {
        node->right = insert(node->right, value);
    }
    else if (value == node->data)
    {
        node->count++;
        return node;
    }
    /* BST insertion ends */

    /* AVL maintenance start */
    node->height = 1 + max(tree_height(node->left), tree_height(node->right));
    node = balance(node);
    /* AVL maintenace end */

    return node;
}

/*
     * Input: int value - the value to remove
     * Returns: N/A
     * Does: Removes value from the tree. If a node's count is greater than
     *      1, the count is decremented and the node is not removed. Nodes
     *      with a count of 1 are removed according to the algorithm
     *      discussed in class, with arbitrary decisions made in the same way
     *      as the reference implementation.
     */
Node *AVLTree::remove(Node *node, int value)
{
    /* BST removal begins */
    if (node == NULL)
    {
        return NULL;
    }

    Node *root = node;
    if (value < node->data)
    {
        node->left = remove(node->left, value);
    }
    else if (value > node->data)
    {
        node->right = remove(node->right, value);
    }
    else
    {
        // We found the value. Remove it.
        if (node->count > 1)
        {
            node->count--;
        }
        else
        {
            if (node->left == NULL && node->right == NULL)
            {
                root = NULL;
                delete node;
                return root;
            }
            else if (node->left != NULL && node->right == NULL)
            {
                root = node->left;
                node->left = NULL;
                delete node;
            }
            else if (node->left == NULL && node->right != NULL)
            {
                root = node->right;
                node->right = NULL;
                delete node;
            }
            else
            {
                Node *replacement = find_min(node->right);
                root->data = replacement->data;
                root->count = replacement->count;
                replacement->count = 1;
                root->right = remove(root->right, replacement->data);
            }
        }
    }
    /* BST removal ends */

    /* AVL maintenance begins */
    if (root != NULL)
    {
        root->height = 1 + max(tree_height(root->left), tree_height(root->right));
        root = balance(root);
    }
    /* AVL maintenance ends */

    return root;
}

/*
     * Input: a node
     * Returns: the height of this
     * Does: computes and returns the height of this tree.
     */
int AVLTree::tree_height(Node *node) const
{
    if (node == nullptr) 
    {
        return 0;
    }

    return node->height;
}

/*
     * Input: a node
     * Returns: The number of nodes in this tree
     * Does: Counts and returns the number of nodes in this
     */
int AVLTree::node_count(Node *node) const
{
    if (node == nullptr) 
    {
        return 0;
    }

    return node_count(node->left) + node_count(node->right) + 1;
}

/*
     * Input: a node
     * Returns: the total of all node values, including duplicates.
     * Does: Computes and returns the sum of all nodes and duplicates in
     *      this
     */
int AVLTree::count_total(Node *node) const
{
    if (node == nullptr) 
    {
        return 0;
    } 
    else 
    {
        return node->data * node->count + 
               count_total(node->left) + count_total(node->right);
    }
}

/*
     * Input: Node node - a pointer to the root of the tree to copy
     * Returns: a deep copy of the tree rooted at node
     * Does: Performs a pre-order traversal of the tree rooted at node to
     *      create a deep copy of it
     */
Node *AVLTree::pre_order_copy(Node *node) const
{
    if (node == nullptr) 
    {
        return nullptr;
    }

    Node* node_copy = new_node(node->data, node->count, node->height, NULL, 
                               NULL);
    node_copy->left = pre_order_copy(node->left);
    node_copy->right = pre_order_copy(node->right);

    return node_copy;
}

/*
     * Input: Node node - a pointer to the root of the tree to delete
     * Returns: N/A
     * Does: Performs a post-order traversal of the tree rooted at node to
     *      delete every node in that tree
     */
void AVLTree::post_order_delete(Node *node)
{
    if (node != NULL) 
    {
        post_order_delete(node->left);
        post_order_delete(node->right);
        delete node;
    }
}

/*
     * Input: Node root - a node of the avl tree.
     * Returns: the balanced subtree.
     * Does: If unbalanced, balances the tree rooted at node.
     */
Node *AVLTree::balance(Node *node)
{
    // check if node is NULL
    if (node == NULL) 
    {
        return NULL;
    }

    // calculate the heights of the nodes 
    int left_height;
    int right_height;

    if(node->left != nullptr)
    {
        left_height = node->left->height;
    }
    else
    {
        left_height = -1;
    }

    if(node->right != nullptr)
    {
        right_height = node->right->height;
    }
    else
    {
        right_height = -1;
    }
    node->height = max(left_height, right_height) + 1;

    // Check for an unbalanced left subtree
    if (height_diff(node) > 1)
    {
        if (height_diff(node->left) < 0)
        {
            node->left = left_rotate(node->left);
        }
        node = right_rotate(node);
    }
    // Check for an unbalanced right subtree
    else if (height_diff(node) < -1)
    {
        if (height_diff(node->right) > 0)
        {
            node->right = right_rotate(node->right);
        }
        node = left_rotate(node);
    }

    return node;
}

/*
     * Input: Node node - a node of the avl tree.
     * Returns: pointer to the root of rotated tree.
     * Does: right rotate tree rooted at node
     */
Node *AVLTree::right_rotate(Node *node)
{
    // reassign nodes for right rotation
    Node* new_root = node->left;
    node->left = new_root->right;
    new_root->right = node;

    // assign node heights for left and right children
    int left_height;
    int right_height;

    if(node->left != nullptr)
    {
        left_height = node->left->height;
    }
    else
    {
        left_height = -1;
    }

    if(node->right != nullptr)
    {
        right_height = node->right->height;
    }
    else
    {
        right_height = -1;
    }
    node->height = 1 + max(left_height, right_height);
    
    // assign node heights from the new root node
    int left_node_height;
    int right_node_height;
    if(new_root->left != nullptr)
    {
        left_node_height = new_root->left->height;
    }
    else
    {
        left_node_height = -1;    
    }

    if(new_root->right != nullptr)
    {
        right_node_height = new_root->right->height;
    }
    else
    {
        right_node_height = -1;    
    }
    new_root->height = 1 + max(left_node_height, right_node_height);

    return new_root;
}

/*
     * Input: Node node - a node of the avl tree.
     * Returns: pointer to the root of rotated tree.
     * Does: left rotate tree rooted at node
     */
Node *AVLTree::left_rotate(Node *node)
{
    // reassign nodes for left rotation
    Node* new_root = node->right;
    node->right = new_root->left;
    new_root->left = node;

    int left_height;
    int right_height;

    // assign heights to original node's left and right children
    if(node->left != nullptr)
    {
        left_height = node->left->height;
    }
    else
    {
        left_height = -1;
    }

    if(node->right != nullptr)
    {
        right_height = node->right->height;
    }
    else
    {
        right_height = -1;
    }
    node->height = 1 + max(left_height, right_height);

    // assign heights to new root node's left and right children
    int left_node_height;
    int right_node_height;
    if(new_root->left != nullptr)
    {
        left_node_height = new_root->left->height;
    }
    else
    {
        left_node_height = -1;    
    }

    if(new_root->right != nullptr)
    {
        right_node_height = new_root->right->height;
    }
    else
    {
        right_node_height = -1;    
    }
    new_root->height = 1 + max(left_node_height, right_node_height);

    return new_root;
}

/*
     * Input: Node node - a node of the avl tree.
     * Returns: integer value signifying the height difference.
     * Does: calculates the difference in the height of the left and child
     *       subtree of node
     */
int AVLTree::height_diff(Node *node) const
{
    int left_height;
    int right_height;

    // check to see if left and right children exist. if so, assign heights 
    // and calculate the difference
    if(node->left != nullptr)
    {
        left_height = node->left->height;
    }
    else
    {
        left_height = -1;
    }
    if(node->right != nullptr)
    {
        right_height = node->right->height;
    }
    else
    {
        right_height = -1;
    }

    return left_height - right_height;
}

/*
     * Input: Node node - the root of the tree in which to search
     *        Node child - a pointer to the the node to search for
     * Returns: a pointer to the parent of child in the tree rooted at
     *      node, or NULL if child is not in that tree
     * Does: Searches the tree rooted at node for child, then returns
     *      that node's parent.
     */
Node *AVLTree::find_parent(Node *node, Node *child) const
{
    if (node == NULL)
        return NULL;

    // if either the left or right is equal to the child,
    // we have found the parent
    if (node->left == child or node->right == child)
    {
        return node;
    }

    // Use the binary search tree invariant to walk the tree
    if (child->data > node->data)
    {
        return find_parent(node->right, child);
    }
    else
    {
        return find_parent(node->left, child);
    }
}
