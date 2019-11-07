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
public class Main {

    public static void main(String[] args) {
        Philosopher[] philosophers = new Philosopher[5];
        Stick[] sticks = new Stick[philosophers.length];
        for (int i = 0; i < sticks.length; i++) {
            sticks[i] = new Stick();
        }

        for (int k = 0; k < philosophers.length; k++) {
            int stickLeft = k;
            int stickRight = k % sticks.length;
            Philosopher philosopher = new Philosopher(sticks[stickLeft], sticks[stickRight]);
            new Thread(philosopher, "Philosopher # " + (k + 1)).start();
        }
    }
}
