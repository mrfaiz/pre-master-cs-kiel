/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.OOP.concurrency;

import java.util.Random;

/**
 *
 * @author Faiz Ahmed
 */
class PhilosopherThreadSafe2 implements Runnable, IPholosopher {

    final StickWithSemaphore left;
    final StickWithSemaphore right;
    Random rand = new Random();

    public PhilosopherThreadSafe2(StickWithSemaphore left, StickWithSemaphore right) {
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
        int randomValue = rand.nextInt();
        if (randomValue % 2 == 0) {
            this.left.getStickThreadSafe();
            this.right.getStickThreadSafe();
        } else {
            this.right.getStickThreadSafe();
            this.left.getStickThreadSafe();
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
}
