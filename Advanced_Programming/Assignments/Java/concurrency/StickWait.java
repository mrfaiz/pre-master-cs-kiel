/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.OOP.concurrency;

import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Faiz Ahmed
 */
public class StickWait {

    boolean available;

    public void getStick() throws InterruptedException {
        synchronized (this) {
            while (!available) {
                wait();
            }
            available = false;
            //this.notifyAll();
        }
    }

    public void putStick() throws InterruptedException {
        synchronized (this) {
            available = true;
            notifyAll();
        }
    }
}
