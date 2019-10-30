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

    public FirstMiniTest(String inputString) {
        this.inputString = inputString;
    }

    public static void main(String[] args) {

        FirstMiniTest test = new FirstMiniTest("Hello Java Kiel Mini Test University");
        System.out.println(". Sort array Elements (Insertion Sort/ quick Sort)\n"
                + "2. Array to Linked List\n"
                + "3. Linked List to Array\n"
                + "4. Sortedly Insert a value in Linked List\n"
                + "5. Delete a value from Linked list (Delete anyone if multiple occurances)\n"
                + "6. Exit");
        while (true) {
            Scanner s = new Scanner(System.in);
            int value = s.nextInt();
            switch (value) {
                case 1:
                    break;
                case 2:

                    break;
                case 3:

                    break;
                case 4:

                    break;
                case 5:

                    break;
                case 6:
                    break;
                default:
                    break;
                //throw new AssertionError();
            }
        }

    }

}
