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
public class PhilosopherWaitNotify implements Runnable, IPholosopher {

    final StickWaitNotify left;
    final StickWaitNotify right;

    public PhilosopherWaitNotify(StickWaitNotify left, StickWaitNotify right) {
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
            //     }
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
            if (this.left.available) {
                this.left.getStick();
                if (this.right.available) {
                    this.right.getStick();
                } else {
                    this.left.putStick();
                }
            }
        } catch (InterruptedException e) {
        }

    }

    @Override
    public void putSticks() {
        try {
            this.left.putStick();
            this.right.putStick();
        } catch (Exception e) {
        }
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
        PhilosopherSemaphoreDeadLockFree[] philosophers = new PhilosopherSemaphoreDeadLockFree[5];
        StickWaitNotify[] sticks = new StickWaitNotify[philosophers.length];
        for (int i = 0; i < sticks.length; i++) {
            sticks[i] = new StickWaitNotify();
        }

        for (int k = 0; k < philosophers.length; k++) {

            int stickLeft = k;
            int stickRight = k + 1;
            if (k == (philosophers.length - 1)) {
                stickRight = 0;
            }
            PhilosopherWaitNotify philosopher = new PhilosopherWaitNotify(sticks[stickLeft], sticks[stickRight]);
            new Thread(philosopher, "Philosopher # " + (k + 1) + " (" + stickLeft + "," + stickRight + ") ").start();
        }

    }
}
