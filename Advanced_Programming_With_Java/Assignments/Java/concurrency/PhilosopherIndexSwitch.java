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
public class PhilosopherIndexSwitch implements Runnable, IPholosopher {

    final StickWithSemaphore left;
    final StickWithSemaphore right;

    public PhilosopherIndexSwitch(StickWithSemaphore left, StickWithSemaphore right) {
        this.left = left;
        this.right = right;
    }

    @Override
    public void run() {
        while (true) {
            think();
            try {
                takeSticks();
                eat();
                putSticks();
            } catch (Exception e) {
            }
        }
    }

    @Override
    public void eat() {
        print("====================eating.....");
        try {
            Thread.sleep(100);
        } catch (Exception e) {
        }
    }

    @Override
    public void takeSticks() {
        try {
            this.left.getStick();
            this.right.getStick();
        } catch (InterruptedException e) {
        }

    }

    @Override
    public void putSticks() {
        this.left.putStick();
        this.right.putStick();
    }

    @Override
    public void think() {
        try {
            print("started thinking.");
            Thread.sleep(100);
        } catch (Exception e) {
        }
    }

    @Override
    public void print(String state) {
        System.out.println(Thread.currentThread().getName() + " " + state);
    }

    public static void main(String[] args) {
        PhilosopherIndexSwitch[] philosophers = new PhilosopherIndexSwitch[5];
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
            PhilosopherIndexSwitch philosopher = new PhilosopherIndexSwitch(sticks[stickLeft], sticks[stickRight]);
            new Thread(philosopher, "Philosopher # " + (k + 1) + " (" + stickLeft + "," + stickRight + ") ").start();
        }
    }
}
