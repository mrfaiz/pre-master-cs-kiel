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
public class Philosopher implements Runnable {

    final Stick left;
    final Stick right;

    public Philosopher(Stick left, Stick right) {
        this.left = left;
        this.right = right;
    }

    @Override
    public void run() {
        while (true) {
            thinking();
            try {
                /*
                // With deadlock prevention
                    synchronized (this.left) {
                    synchronized (this.right) {
                        printPhilosopherState("picke up right fork, ===========eating.");
                        eat();
                        printPhilosopherState("put down right fork, holding left fork.");
                    }
                    printPhilosopherState("put down left fork, back to thinking.");
                }
                 */

                // With Dead lock == start==
                this.left.getStick();
                printPhilosopherState("Token left");
                this.right.getStick();
                eat();
                this.right.putStick();
                this.left.putStick();
                // With Dead lock == End==
            } catch (Exception e) {
            }
        }
    }

    private void eat() {
        printPhilosopherState("========eating.....");
        try {
            Thread.sleep(100);
        } catch (Exception e) {
        }
    }

    private void thinking() {
        try {
            printPhilosopherState("started thinking.");
            Thread.sleep(100);
        } catch (Exception e) {
        }
    }

    private void printPhilosopherState(String state) {
        System.out.println(Thread.currentThread().getName() + " " + state);
    }
}
