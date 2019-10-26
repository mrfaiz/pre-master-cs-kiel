
/**
 * <b>Assignment 3</b>
 * <br>
 * Extend the class LinkedList from the lecture by a method unRemove, which adds
 * an element to the front of a LinkedList. Furthermore, implement a method
 * toArray, which converts a LinkedList into an Array.
 *
 * @author Faiz Ahmed
 *
 */
public class LinkedList {

    private Node head;
    private Node tail;
    private int size;

    public void add(int value) {
        Node newNode = new Node(value);
        if (head == null) {
            head = newNode;
            size = 0;
        } else {
            tail.next = newNode;
        }
        tail = newNode;
        size++;
    }

    public int remove() {
        if (head == null) {
            return -1;
        }
        Node currentHead = head;
        if (head == tail) {// Single element
            head = tail = null;
        } else {
            head = head.next;
        }
        size--;
        return currentHead.value;
    }

    /**
     * Insert a element into head
     *
     * @param value
     */
    public void unRemove(int value) {
        if (head == null) {
            add(value);
        } else {
            Node node = new Node(value);
            node.next = head;
            head = node;
            size++;
        }
    }

    public int[] toArray() {
        final int M = 100;
        int[] array = new int[getSize()];
        if (head != null) {
            Node last = head;
            int i = 0;
            while (true) {
                array[i] = last.value;
                if (last.next == null) {
                    break;
                }
                last = last.next;
                i++;
            }
        }
        return array;
    }

    public int getSize() {
        return size;
    }

    public void print() {
        int[] add = toArray();
        for (int i = 0; i < add.length; i++) {
            System.out.println(add[i]);
        }
    }

    class Node {

        int value;
        Node next;

        public Node(int value) {
            this.value = value;
        }

        public void addNext(Node next) {
            this.next = next;
        }
    }

    public static void main(String[] args) {
        LinkedList bl = new LinkedList();
        bl.add(3);
        bl.add(13);
        bl.add(35);
        bl.add(33);
        bl.add(2);
        bl.unRemove(1);
        System.out.println("Before Remove");
        bl.print();
        bl.remove();
        bl.remove();
        System.out.println("After Remove");
        bl.print();
        //  bl.printLinkedList();
    }
}
