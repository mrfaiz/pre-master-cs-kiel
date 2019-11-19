/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.OOP.concurrency;

import java.util.Random;
import java.util.concurrent.ThreadLocalRandom;

/**
 *
 * @author Faiz Ahmed
 */
class PhilosopherSemaphoreDeadLockFree implements Runnable, IPholosopher {

    final StickWithSemaphore left;
    final StickWithSemaphore right;
    Random rand = new Random();

    public PhilosopherSemaphoreDeadLockFree(StickWithSemaphore left, StickWithSemaphore right) {
        this.left = left;
        this.right = right;
    }

    @Override
    public void run() {
        while (true) {
            think();
            try {
                //takeSticks();
                if (takeTwoSticks()) {
                    eat();
                    putSticks();
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void eat() {
        print("====================eating.....");
        try {
            Thread.sleep(ThreadLocalRandom.current().nextInt(10, 200));
        } catch (Exception e) {
        }
    }

    public boolean takeTwoSticks() throws InterruptedException {
//        this.left.getStickThreadSafe();
//        this.right.getStickThreadSafe();
        boolean take = false;
        while (true) {
            if (this.left.semaphore.availablePermits() > 0) {
                this.left.semaphore.acquire();
                if (this.right.semaphore.availablePermits() > 0) {
                    this.right.semaphore.acquire();
                    take = true;
                    break;
                } else {
                    this.left.semaphore.release();
                }
            }
        }
        return take;
    }

    @Override
    public void takeSticks() {
//        this.left.getStickThreadSafe();
//        this.right.getStickThreadSafe();
        try {
            if (this.left.semaphore.availablePermits() > 0) {
                this.left.semaphore.acquire();
                if (this.right.semaphore.availablePermits() > 0) {
                    this.right.semaphore.acquire();
                } else {
                    this.left.semaphore.release();
                }
            }
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
        PhilosopherSemaphoreDeadLockFree[] philosophers = new PhilosopherSemaphoreDeadLockFree[5];
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
            PhilosopherSemaphoreDeadLockFree philosopher = new PhilosopherSemaphoreDeadLockFree(sticks[stickLeft], sticks[stickRight]);
            new Thread(philosopher, "Philosopher # " + (k + 1) + " (" + stickLeft + "," + stickRight + ") ").start();
        }
    }
}
