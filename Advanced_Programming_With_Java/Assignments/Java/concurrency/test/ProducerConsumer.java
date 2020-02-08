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
public class ProducerConsumer {

    public static void main(String[] args) {
        Producer producer = new Producer();
        Consumer consumer = new Consumer(producer);

        new Thread(producer, "Producer").start();
        new Thread(consumer, "Consumer").start();
    }

}
