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
public class Transfer implements Runnable {

    Account source;
    Account destinaiton;
    int amountToTranser;

    public Transfer(int amount, Account source, Account destinaiton) {
        this.source = source;
        this.destinaiton = destinaiton;
        this.amountToTranser = amount;
    }

    @Override
    public void run() {
        for (int i = 1; i <= this.amountToTranser; i++) {
            // this.source.transfer(this.destinaiton, 1);
            this.source.transferWithOutDeadLock(this.destinaiton, 1);
        }
        System.out.println("Balance of " + Thread.currentThread().getName() + " " + this.source.getBalance());
    }

    public static void main(String[] args) {
        int initAmount = 10000000;
        int transferAmount = 500;
        Account a = new Account(initAmount, 1);
        Account b = new Account(initAmount, 2);
//        Account c = new Account(initAmount, 2);
//        Account d = new Account(initAmount, 2);
//        Account e = new Account(initAmount, 2);
//        Account f = new Account(initAmount, 2);

        Thread tha = new Thread(new Transfer(transferAmount, a, b), "A");
        Thread thb = new Thread(new Transfer(transferAmount, b, a), "B");
//        Thread thc = new Thread(new Transfer(transferAmount, a, b), "C");
//        Thread thd = new Thread(new Transfer(transferAmount, b, a), "D");
//        Thread the = new Thread(new Transfer(transferAmount, a, b), "E");
//        Thread thf = new Thread(new Transfer(transferAmount, a, b), "F");
        tha.start();
        thb.start();
//        thc.start();
//        thd.start();
//        the.start();
//        thf.start();

    }
}
