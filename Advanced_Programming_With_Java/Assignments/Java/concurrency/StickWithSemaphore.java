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
public class StickWithSemaphore extends Stick {

    public java.util.concurrent.Semaphore semaphore = new java.util.concurrent.Semaphore(1);

    boolean available;

    public void getStick() throws InterruptedException {
        semaphore.acquire();
        available = false;
    }

    public void getStickThreadSafe() {
        semaphore.acquireUninterruptibly();
        available = false;
    }

    public void putStick() {
        semaphore.release();
        available = true;
    }
}
