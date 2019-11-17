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
public class PhilosopherThreadSafe1 implements Runnable, IPholosopher {

    final StickWithSemaphore left;
    final StickWithSemaphore right;

    public PhilosopherThreadSafe1(StickWithSemaphore left, StickWithSemaphore right) {
        this.left = left;
        this.right = right;
    }

    @Override
    public void run() {
        while (true) {
            think();
            try {
//                if (this.left.semaphore.tryAcquire()) {
//                    printPhilosopherState("picke up left fork waiting for right..");
//                    if (this.right.semaphore.tryAcquire()) {
//                        printPhilosopherState("picke up right fork, ===========eating.");
//                        eat();
//                    }
//                } else if (this.right.semaphore.tryAcquire()) {
//                    printPhilosopherState("picke up right fork waiting for left..");
//                    if (this.left.semaphore.tryAcquire()) {
//                        printPhilosopherState("picked up left fork, ===========eating.");
//                        eat();
//                    }
//                    this.right.putStick();
//                }

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

//    private void takeSticksThreadSafe() {
//        this.left.getStickThreadSafe();
//        this.right.getStickThreadSafe();
//    }
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
