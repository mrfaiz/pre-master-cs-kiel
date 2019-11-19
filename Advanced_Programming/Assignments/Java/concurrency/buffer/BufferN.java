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
public final class BufferN<T> {

    public T[] buffer;
    int capacity;
    int front, rear;
    int size;

    public BufferN(int capacity) {
        if (capacity <= 0) {
            throw new IllegalArgumentException("Capacity should be greater then zero!");
        }
        this.capacity = capacity;
        buffer = (T[]) new Object[this.capacity];
        this.init();
    }

    public T[] getBuffer() {
        return buffer;
    }

    public synchronized boolean isEmpty() {
        return size == 0;
    }

    public synchronized boolean isFull() {
        return size == capacity;
    }

    public synchronized T take() throws InterruptedException {
        while (isEmpty()) {
            wait();
        }
        T value = buffer[front];
        buffer[front] = null;
        front++;
        size--;
        if (size == 0) {
            init();
        }
        notifyAll();
        //  System.out.println("put: take=>" + rear + " front=>" + front + " size=>" + size);
        return value;
    }

    public synchronized void put(T elem) throws InterruptedException {
        while (isFull()) {
            wait();
        }
        if (rear == (capacity - 1)) {
            rear = 0;
        } else {
            rear++;
        }
        size++;
        buffer[rear] = elem;
        notifyAll();
    }

    void init() {
        front = 0;
        rear = -1;
        size = 0;
    }

    public void printBuffer(String note) {
        System.out.println("\n" + note);
        for (T t : buffer) {
            System.out.print(t + " ");
        }
        System.out.println("put: rear=>" + rear + " front=>" + front + " size=>" + size);
    }

    public static void main(String[] args) {
        BufferN<Integer> b = new BufferN(10);
        try {
            b.put(50);
            b.put(44);
            b.put(53);
            b.put(22);
            b.put(24);
            b.put(11);
            b.put(32);
            b.put(233);
            b.put(565);
            b.put(1200);
            //  b.put(804);

            b.printBuffer("After Insert");
            b.take();
            b.take();
            b.take();
            b.take();
            b.take();
            b.take();
            b.take();
            b.take();
            b.take();
            b.take();
            b.printBuffer("After deleting 10 nodes");
            b.put(200);
            b.take();
            b.printBuffer("After insert and delete again");
            b.put(50);
            b.put(44);
            b.put(53);
            b.put(22);
            b.put(24);
            b.put(11);
            b.put(32);
            b.put(233);
            b.put(565);
            b.put(1200);
            b.printBuffer("Inserted 10 node");
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
