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
public class StickWaitNotify {

    boolean available;

    public synchronized void getStick() throws InterruptedException {
//        synchronized (this) {
        while (!available) {
            wait();
        }
        available = false;
        //this.notifyAll();
//        }
    }

    public void putStick() throws InterruptedException {
        synchronized (this) {
            available = true;
            notify();
        }
    }
}
