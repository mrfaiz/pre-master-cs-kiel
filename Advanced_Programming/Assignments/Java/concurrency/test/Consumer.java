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
public class Consumer implements Runnable {

    Producer producer;

    public Consumer(Producer producer) {
        this.producer = producer;
    }

    @Override
    public void run() {

        while (true) {
            try {
                System.out.println(this.producer.getMessage());
                Thread.sleep(200);
            } catch (InterruptedException e) {
            }
        }
    }
}
