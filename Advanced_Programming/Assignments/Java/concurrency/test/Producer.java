/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.OOP.concurrency.test;

/**
 *
 * @author Faiz Ahmed
 */
public class Producer implements Runnable {

    private final int MAX_SIZE = 10;
    private java.util.Vector vector = new java.util.Vector<>();

    @Override
    public void run() {
        while (true) {
            try {
                putMessage();
                //  Thread.sleep(500);
            } catch (InterruptedException ex) {
                Thread.currentThread().interrupt();
            }
        }
    }

    private synchronized void putMessage() throws InterruptedException {
        while (vector.size() == MAX_SIZE) {
            wait();
        }
        vector.add(new java.util.Date().toString());
        System.out.println("Element inserted....");
        notify();
    }

    public synchronized String getMessage() throws InterruptedException {
        while (vector.isEmpty()) {
            wait();
        }
        String message = (String) vector.firstElement();
        vector.removeElement(message);
        notify();
        return message;
    }
}
