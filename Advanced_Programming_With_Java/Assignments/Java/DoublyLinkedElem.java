/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Faiz Ahmed
 * @param <T>
 *
 */
public class DoublyLinkedElem<T> {

    T value;
    DoublyLinkedElem<T> left;
    DoublyLinkedElem<T> right;
    // DoublyLinkedElem<T> head;

    public DoublyLinkedElem(T value, DoublyLinkedElem<T> left, DoublyLinkedElem<T> right) {
        this.value = value;
        this.add(left, right);
    }

    /**
     * e1 = new DoublyLinkedElem<Integer>(42,None,None); <br>
     * e2 = new DoublyLinkedElem<Integer>(44,e1,None);  <br>
     * e3 = new DoublyLinkedElem<Integer>(43,e1,e2);  <br>
     * e0 = new DoublyLinkedElem<Integer>(41,None,e1); <br>
     *
     * System.out.println(e2.to_list()); # output: 41<->42<->43<->44  <br>
     * e3.remove(); <br>
     *
     * System.out.println(e1.to_list()); # output: 41<->42<->44 <br>
     *
     * e0.remove(); <br>
     *
     * System.out.println(e1.to_list()); # output: 42<->44 <br>
     *
     * @param left
     * @param right
     */
    private void add(DoublyLinkedElem<T> left, DoublyLinkedElem<T> right) {
        if (left != null && right != null) {
            this.right = right;
            right.left = this;

            this.left = left;
            left.right = this;
        } else if (left != null) {
            if (left.right != null) {
                this.right = left.right;
                left.right.left = this;
            }
            left.right = this;
            this.left = left;
        } else if (right != null) {
            if (right.left != null) {
                this.left = right.left;
                right.left.right = this;
            }
            this.right = right;
            right.left = this;
        }
    }

    private void remove() {
        if (this.left != null && this.right != null) {
            this.left.right = this.right;
            this.right.left = this.left;
        } else if (this.left != null) {
            this.left.right = null;
        } else if (this.right != null) {
            this.right.left = null;
        } else {
        }
    }

    public String to_list() {
        StringBuilder result = new StringBuilder();
        DoublyLinkedElem<T> head;
        if (this.left != null) {
            head = this;
            while (true) {
                if (head.left == null) {
                    break;
                } else {
                    head = head.left;
                }
            }
        } else {
            head = this;
        }

        while (true) {
            if (head.value != null) {
                if (head.right == null) {
                    result.append(head.value);
                    break;
                } else {
                    result.append(head.value).append("<->");
                    head = head.right;
                }
            }
        }
        return result.toString();
    }

    public static void main(String[] args) {
        DoublyLinkedElem<Integer> e1 = new DoublyLinkedElem<>(42, null, null);
        DoublyLinkedElem<Integer> e2 = new DoublyLinkedElem<>(44, e1, null);
        DoublyLinkedElem<Integer> e3 = new DoublyLinkedElem<>(43, e1, e2);
        DoublyLinkedElem<Integer> e0 = new DoublyLinkedElem<>(41, null, e1);

        System.out.println("output: " + e2.to_list());
        e3.remove();
        System.out.println("output: " + e1.to_list());
        e0.remove();
        System.out.println("output: " + e1.to_list());

    }
}
