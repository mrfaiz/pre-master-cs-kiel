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
public class NthPrimeNumber {

    private boolean isPrime(int number) {
        double sqNumber = Math.sqrt((double) number);
        for (int i = 2; i <= sqNumber; i++) {
            if (number % i == 0) {
                return false;
            }
        }
        return true;
    }

    public int getNthPrime(int n) {
        int i = 0;
        int initNumber = 1;
        while (true) {
            initNumber++;
            if (isPrime(initNumber)) {
                i++;
              //  System.out.println(i + "th Prime is  " + initNumber);
            }
            if (i == n) {
                break;
            }
        }

        return initNumber;
    }

    public static void main(String[] args) {
        NthPrimeNumber nn = new NthPrimeNumber();
        //System.out.println(nn.isPrime(23));
        //  System.out.println(nn.getNthPrime(3));
        Scanner sc = new Scanner(System.in);
        System.out.print("Enter nth number: ");
        int nthNumber = sc.nextInt();
        int nthPrimeNumber = nn.getNthPrime(nthNumber);
        System.out.println(nthNumber + " Prime number is " + nthPrimeNumber);
    }

}
