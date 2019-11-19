/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.OOP.buffer;

/**
 *
 * @author Faiz Ahmed
 */
public class Buffer1<T> {

    boolean empty;
    T content;

    Buffer1() {
        empty = true;
        content = null;
    }

    Buffer1(T v) {
        empty = false;
        content = v;
    }

    public synchronized T take() throws InterruptedException {
        while (empty) {
            this.wait();
        }
        empty = true;
        T help = content;
        content = null;
        this.notifyAll();
        return help;
    }

    public synchronized void put(T v) throws InterruptedException {
        while (!empty) {
            this.wait();
        }
        empty = false;
        content = v;
        this.notifyAll();
    }
}
