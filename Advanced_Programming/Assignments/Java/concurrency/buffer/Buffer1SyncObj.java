/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.OOP.buffer;

import java.util.concurrent.TimeoutException;

/**
 *
 * @author Faiz Ahmed
 * @param <T>
 */
public class Buffer1SyncObj<T> {

    boolean empty;
    T content;

    private final Object r = new Object();
    private final Object w = new Object();

    Buffer1SyncObj() {
        empty = true;
        content = null;
    }

    Buffer1SyncObj(T v) {
        empty = false;
        content = v;
    }

    public T take() throws InterruptedException {
        synchronized (r) {
            while (empty) {
                r.wait();
            }
            synchronized (w) {
                empty = true;
                T help = content;
                content = null;
                w.notify();
                return help;
            }
        }
    }

    public void put(T v) throws InterruptedException {
        synchronized (w) {
            while (!empty) {
                w.wait();
            }
            synchronized (r) {
                empty = false;
                content = v;
                r.notify();
            }
        }
    }

    public boolean tryPut(T v) throws InterruptedException {
        synchronized (w) {
            if (empty) {
                synchronized (r) {
                    boolean isEmpty = empty;
                    empty = false;
                    content = v;
                    r.notify();
                    return isEmpty;
                }
            } else {
                return false;
            }
        }
    }

    public T read() throws InterruptedException {
        synchronized (r) {
            while (empty) {
                r.wait();
            }
            synchronized (w) {
                T c = content;
                r.notify();
                return c;
            }
        }
    }

    public void overwrite(T v) throws InterruptedException {
        synchronized (w) {
            content = v;
            if (empty) {
                synchronized (r) {
                    empty = false;
                    r.notify();
                }
            }
        }
    }

    public T take(long timeout) throws InterruptedException, TimeoutException {
        synchronized (r) {
            if (empty) {
                r.wait(timeout);
            }
            if (empty) {
                throw new TimeoutException();
            }
            synchronized (w) {
                empty = true;
                T help = content;
                content = null;
                w.notify();
                return help;
            }
        }
    }

    public static void main(String[] args) {
        Buffer1SyncObj<Integer> bf = new Buffer1SyncObj<>();
        long millis = System.currentTimeMillis();
        try {
            bf.take(1000);
        } catch (InterruptedException | TimeoutException ex) {
            ex.printStackTrace();
        }
        System.out.println(System.currentTimeMillis() - millis);
    }
}
