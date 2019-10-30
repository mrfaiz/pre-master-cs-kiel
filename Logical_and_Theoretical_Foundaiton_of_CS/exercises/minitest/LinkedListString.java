/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


//import com.mycompany.linkedlist.LinkedList;
/**
 *
 * @author Faiz Ahmed
 */
public class LinkedListString {

    private Node head;
    private Node tail;
    private int size;

    public void add(String value) {
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

    public String remove() {
        if (head == null) {
            return null;
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
    public void unRemove(String value) {
        if (head == null) {
            add(value);
        } else {
            Node node = new Node(value);
            node.next = head;
            head = node;
            size++;
        }
    }

    public String[] toArray() {
        final int M = 100;
        String[] array = new String[getSize()];
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
        String[] add = toArray();
        for (String add1 : add) {
            System.out.print(add1 + " ");
        }
    }

    public void insertIntoList(String s) {
        if (head != null) {
            Node last = head;
            while (true) {
                if (last.value.compareTo(s) < 0) {
                    last = last.next;
                } else {
                    break;
                }
            }
            Node n = new Node(s);
            Node prvValue = last.next;
            last.next = n;
            n.next = prvValue;
            size++;
        }
    }

    public boolean delete(String s) {
        if (head != null) {
            Node last = head;
            while (last != null) {
                if (last.value.compareTo(s) == 0) {
                    last = last.next;
                }
            }
        }
        return true;
    }

    class Node {

        String value;
        Node next;

        public Node(String value) {
            this.value = value;
        }

        public void addNext(Node next) {
            this.next = next;
        }
    }

    public static void main(String[] args) {
        LinkedListString bl = new LinkedListString();
        bl.add("SsSS");
        bl.add("sakdlfj");
        // bl.unRemove();
        System.out.println("Before Remove");
        bl.print();
        ////   bl.remove();
        //bl.remove();
        //System.out.println("After Remove");
        //bl.print();
        //  bl.printLinkedList();
    }
}
