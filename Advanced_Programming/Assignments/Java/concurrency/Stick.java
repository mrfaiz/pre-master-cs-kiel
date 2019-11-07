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
public class Stick {

    private boolean available=true;
    public java.util.concurrent.Semaphore semaphore = new java.util.concurrent.Semaphore(1);

    public boolean isAvailable() {

        return semaphore.availablePermits()>0?true:false;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public void getStick() throws InterruptedException {
        semaphore.acquire();
        available = false;

    }

    public void putStick() {
        available = true;
        semaphore.release();
    }
}
