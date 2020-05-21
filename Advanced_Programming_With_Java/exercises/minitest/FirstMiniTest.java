/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.util.Scanner;

/**
 *
 * @author Faiz Ahmed
 */
public class FirstMiniTest {

    public String inputString = null;
    LinkedListString linkedList = new LinkedListString();
    QuickSortString quick = new QuickSortString();

    public FirstMiniTest(String inputString) {
        this.inputString = inputString;
    }

    public void task1() {
        String[] array = quick.toArray(inputString);
        quick.sort(array, 0, array.length - 1);
        quick.printArray(array);
    }

    public void task2() {
        String[] array = quick.toArray(inputString);
        quick.sort(array, 0, array.length - 1);
        for (String s : array) {
            linkedList.add(s);
        }
        linkedList.toLinkedList();
    }

    public void task3() {
        String[] array = quick.toArray(inputString);
        quick.sort(array, 0, array.length - 1);
        for (String s : array) {
            linkedList.add(s);
        }
        linkedList.toArray();
    }

    public void task4(String s) {
        linkedList.insertIntoList(s);
        linkedList.toArray();
    }

    public void task5(String s) {
        linkedList.delete(s);
    }

    public void task6() {
        System.exit(0);
    }

    public static void main(String[] args) {

        FirstMiniTest test = new FirstMiniTest("java FirstMiniTest Hello Kiel University Java Mini Test");
        Scanner s;
        while (true) {
            System.out.println("1. Sort array Elements (Insertion Sort/ quick Sort)\n"
                    + "2. Array to Linked List\n"
                    + "3. Linked List to Array\n"
                    + "4. Sortedly Insert a value in Linked List\n"
                    + "5. Delete a value from Linked list (Delete anyone if multiple occurances)\n"
                    + "6. Exit");

            s = new Scanner(System.in);
            int value = s.nextInt();
            switch (value) {
                case 1:
                    //  test = new FirstMiniTest(input);
                    test.task1();
                    break;
                case 2:
                    test.task2();
                    break;
                case 3:
                    test.task3();
                    break;
                case 4:
                    test.task4("HRS");
                    break;
                case 5:
                    test.task5("Mini");
                    break;
                case 6:
                    test.task6();
                    break;
                default:
                    break;
                //throw new AssertionError();
            }
        }

    }

}

