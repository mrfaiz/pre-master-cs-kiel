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
public class PhilosopherWN implements Runnable, IPholosopher {

    final StickWait left;
    final StickWait right;

    public PhilosopherWN(StickWait left, StickWait right) {
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
            this.left.getStick();
            this.right.getStick();
        } catch (InterruptedException e) {
        }

    }

//    private void takeSticksThreadSafe() {
//        this.left.getStickThreadSafe();
//        this.right.getStickThreadSafe();
//    }
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
        PhilosopherThreadSafe2[] philosophers = new PhilosopherThreadSafe2[5];
        StickWait[] sticks = new StickWait[philosophers.length];
        for (int i = 0; i < sticks.length; i++) {
            sticks[i] = new StickWait();
        }

        for (int k = 0; k < philosophers.length; k++) {

            int stickLeft = k;
            int stickRight = k + 1;
            if (k == (philosophers.length - 1)) {
                stickRight = 0;
            }
            PhilosopherWN philosopher = new PhilosopherWN(sticks[stickLeft], sticks[stickRight]);
            new Thread(philosopher, "Philosopher # " + (k + 1) + " (" + stickLeft + "," + stickRight + ") ").start();
        }

    }
}
