/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.OOP.concurrency;

/**
 *
 * @author Faiz Ahmed
 */
public class Main {

    public static void problem1() {
        PhilosopherThreadSafe1[] philosophers = new PhilosopherThreadSafe1[5];
        StickWithSemaphore[] sticks = new StickWithSemaphore[philosophers.length];
        for (int i = 0; i < sticks.length; i++) {
            sticks[i] = new StickWithSemaphore();
        }

        for (int k = 0; k < philosophers.length; k++) {

            int stickLeft = k;
            int stickRight = k + 1;
            if (k == (philosophers.length - 1)) {
                // stickRight = 0;
                stickLeft = 0;
                stickRight = k;
            }
            PhilosopherThreadSafe1 philosopher = new PhilosopherThreadSafe1(sticks[stickLeft], sticks[stickRight]);
            new Thread(philosopher, "Philosopher # " + (k + 1) + " (" + stickLeft + "," + stickRight + ") ").start();
        }
    }

    public static void problem1_b() {
        PhilosopherThreadSafe2[] philosophers = new PhilosopherThreadSafe2[5];
        StickWithSemaphore[] sticks = new StickWithSemaphore[philosophers.length];
        for (int i = 0; i < sticks.length; i++) {
            sticks[i] = new StickWithSemaphore();
        }

        for (int k = 0; k < philosophers.length; k++) {

            int stickLeft = k;
            int stickRight = k + 1;
            if (k == (philosophers.length - 1)) {
                stickRight = 0;
            }
            PhilosopherThreadSafe2 philosopher = new PhilosopherThreadSafe2(sticks[stickLeft], sticks[stickRight]);
            new Thread(philosopher, "Philosopher # " + (k + 1) + " (" + stickLeft + "," + stickRight + ") ").start();
        }
    }

    public static void problem2() {
        PhilosopherSync[] philosophers = new PhilosopherSync[5];
        Stick[] sticks = new Stick[philosophers.length];
        for (int i = 0; i < sticks.length; i++) {
            sticks[i] = new StickWithSemaphore();
        }

        for (int k = 0; k < philosophers.length; k++) {
            int stickLeft = k;
            int stickRight = (k + 1) % sticks.length;
            PhilosopherSync philosopher = new PhilosopherSync(sticks[stickLeft], sticks[stickRight]);
            new Thread(philosopher, "Philosopher # " + (k + 1)).start();
        }
    }

    public static void main(String[] args) {
        // problem1();
       // problem1_b();
      problem2();

    }
}
