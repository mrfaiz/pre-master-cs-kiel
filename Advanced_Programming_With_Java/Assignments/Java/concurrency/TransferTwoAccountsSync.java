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
public class TransferTwoAccountsSync implements Runnable {

    Account source;
    Account destinaiton;
    int amountToTranser;

    public TransferTwoAccountsSync(int amount, Account source, Account destinaiton) {
        this.source = source;
        this.destinaiton = destinaiton;
        this.amountToTranser = amount;
    }

    @Override
    public void run() {
        for (int i = 1; i <= this.amountToTranser; i++) {
            this.source.transferWithoutDeadLock(this.destinaiton, 1);
        }
        System.out.println("Balance of " + Thread.currentThread().getName() + " " + this.source.getBalance());
    }

    public static void main(String[] args) {
        int initAmount = 10000000;
        int transferAmount = 500;
        Account a = new Account(initAmount, 1);
        Account b = new Account(initAmount, 2);

        Thread tha = new Thread(new TransferTwoAccountsSync(transferAmount, a, b), "A");
        Thread thb = new Thread(new TransferTwoAccountsSync(transferAmount, b, a), "B");
        tha.start();
        thb.start();
    }
}
