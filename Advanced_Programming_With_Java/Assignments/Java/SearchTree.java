/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Exercise 4:
 * <br>
 * Implement a class SearchTree for binary search trees, without balancing. You
 * should model your data similar to the LinkedList from the lecture, except
 * that you only store the root element and use two next pointers for the two
 * subtrees. Your class should provide methods for inserting a new element,
 * checking whether an element occurs and deleting an element. Also provide a
 * method for converting a search tree into an array.
 * <br>You can restrict your implementation to elements of type int. If you are
 * already familiar with generics, you can also use a type variable, which
 * extends the Comparator interface.
 *
 *
 * @author Faiz Ahmed
 */
public class SearchTree {

    Node root;
    int numberOfNode = 0;

    void insert(int value) {
        Node newnode = new Node(value, null, null);
        if (root == null) {
            root = newnode;
            // System.out.println("value=>" + value);
        } else {
            Node temp = root;
            while (true) {
                //System.out.println(value);
                if (value > temp.value) {
                    if (temp.right == null) {
                        //       System.out.println(temp.value + " Right=>" + value);
                        temp.right = newnode;
                        break;
                    } else {
                        temp = temp.right;
                    }
                } else {
                    if (temp.left == null) {
                        temp.left = newnode;
                        //     System.out.println(temp.value + " Left=" + value);
                        break;
                    } else {
                        temp = temp.left;
                    }

                }
            }
        }
        numberOfNode++;
    }

    void inOrderTraverse(Node subTreeRoot) {
        if (subTreeRoot == null) {
            return;
        }
        inOrderTraverse(subTreeRoot.left);
        System.out.print(subTreeRoot.value + " ");
        inOrderTraverse(subTreeRoot.right);
    }

    Node find(Node node, int value) {
        if (node == null) {
            return null;
        }
        if (node.value == value) {
            return node;
        }
        if (value < node.value) {
            return find(node.left, value);
        }
        return find(node.right, value);
    }

    boolean delete(int value) {
        Node parent = root;
        Node current = root;
        boolean isLeftNode = false;

        while (current.value != value) {
            parent = current;
            if (value < current.value) {
                current = current.left;
                isLeftNode = true;
            } else {
                current = current.right;
                isLeftNode = false;
            }
            if (current == null) {
                return false;
            }
        }
        if (current.left == null && current.right == null) {
            if (current == root) {
                root = null;
            }
            if (isLeftNode) {
                parent.left = null;
            } else {
                parent.right = null;
            }
        } else if (current.right == null) {
            if (current == root) {
                root = current.left;
            } else if (isLeftNode) {
                parent.left = current.left;
            } else {
                parent.right = current.left;
            }
        } else if (current.left == null) {
            if (current == root) {
                root = current.right;
            } else if (isLeftNode) {
                parent.left = current.right;
            } else {
                parent.right = current.right;
            }
        } else if (current.left != null && current.right != null) {
            System.out.println("\ncurrent.left=>" + current.left.value + " current.right=>" + current.right.value);
            Node smallestNode = getRightSmallestNode(current);
            if (current == root) {
                root = smallestNode;
            } else if (isLeftNode) {
                parent.left = smallestNode;
            } else {
                parent.right = smallestNode;
            }
            smallestNode.left=current.left;
        }
        return true;
    }

    private Node getRightSmallestNode(Node nodeToDelete) {
        Node currentNode = nodeToDelete.right;
        Node smallestNode =null;
        Node parentOfSmallestNode = null;
        //if (currentNode.left != null && currentNode.right != null) {
        while (currentNode != null) {
            parentOfSmallestNode = smallestNode;
            smallestNode = currentNode;
            currentNode = currentNode.left;
            // smallestNode=currentNode;

        }

        if (smallestNode != nodeToDelete.right) {
            // i.e. if smallestNode have a right subtree
            parentOfSmallestNode.left = smallestNode.right;
            smallestNode.right=nodeToDelete.right;
        }
        //}
        return smallestNode;
    }

    public static void main(String[] args) {
        SearchTree st = new SearchTree();
        st.insert(55);
        st.insert(70);
        st.insert(30);
        st.insert(90);
        st.insert(60);
        st.insert(40);
        st.insert(20);
        st.insert(48);
        st.insert(10);
        st.insert(25);
        st.insert(35);
        st.insert(33);
        st.insert(38);
        st.insert(37);
        st.insert(39);
        st.insert(31);
        st.insert(34);
        st.insert(50);
        st.insert(51);
        st.insert(52);
        st.insert(8);
        st.insert(9);
        st.insert(6);
        st.insert(32);

        Node search = st.find(st.root, 88);
        System.out.println(search == null ? "Not found" : "Exists!");
        //  st.printSearchTree();
        st.inOrderTraverse(st.root);
        int deleted = 10;
        System.out.println("\ndeleting " + deleted + " : " + st.delete(deleted));
        System.out.println("After delete :");
        st.inOrderTraverse(st.root);

    }

    class Node {

        int value;
        Node left;
        Node right;

        public Node(int value, Node left, Node right) {
            this.value = value;
            this.left = left;
            this.right = right;
        }
    }
}
