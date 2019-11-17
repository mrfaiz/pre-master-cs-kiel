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
public class PhilosopherSync implements Runnable, IPholosopher {

    final Stick left;
    final Stick right;

    public PhilosopherSync(Stick left, Stick right) {
        this.left = left;
        this.right = right;
    }

    @Override
    public void run() {
        while (true) {
            //  thinking();
            try {
                synchronized (this.left) {
                    synchronized (this.right) {
                        print("picked up right fork, ===========eating.");
                        eat();
                        print("put down right fork, holding left fork.");
                    }
                    print("put down left fork, back to ==thinking==.");
                }
            } catch (Exception e) {
            }
        }
    }

    @Override
    public void eat() {
        print("========eating.....");
        try {
            Thread.sleep(100);
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
        // System.out.println(Thread.currentThread().getName() + " " + state);
    }

    @Override
    public void takeSticks() {
        // throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public void putSticks() {
        // throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
}
