/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.OOP.concurrency.test;

/**
 *
 * @author Faiz Ahmed
 */
public class ThreadA {

    public static void main(String[] args) {
        ThreadB b = new ThreadB();
        b.start();

        synchronized (b) {
            try {
                System.out.println("Waiting for b to complete...");
                b.wait();
            } catch (Exception e) {
                e.printStackTrace();
            }

            System.out.println("Total is: " + b.total);
        }
        System.out.println("Total is: " + b.total);
        System.out.println("Competed");
    }
}

class ThreadB extends Thread {

    int total;

    @Override
    public void run() {
        synchronized (this) {
            for (int i = 0; i < 100; i++) {
                total += i;
            }
//            try {
//                Thread.sleep(4000);
//            } catch (Exception e) {
//            }
            notify();
        }
    }
}
