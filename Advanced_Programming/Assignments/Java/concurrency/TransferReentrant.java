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
public class TransferReentrant implements Runnable {

    AccountReentrant source;
    AccountReentrant destinaiton;
    int amountToTranser;

    public TransferReentrant(int amount, AccountReentrant source, AccountReentrant destinaiton) {
        this.source = source;
        this.destinaiton = destinaiton;
        this.amountToTranser = amount;
    }

    @Override
    public void run() {
        for (int i = 1; i <= this.amountToTranser; i++) {
            this.source.transferWithOutDeadLock(this.destinaiton, 1);
        }
        System.out.println("Destinaiton Balance " + Thread.currentThread().getName() + " " + this.destinaiton.getBalance());
    }

    public static void main(String[] args) {
        int initAmount = 10000000;
        int transferAmount = 500000;
        AccountReentrant a = new AccountReentrant(initAmount, 1);
        AccountReentrant b = new AccountReentrant(initAmount, 2);
        Thread tha = new Thread(new TransferReentrant(transferAmount, a, b), "A");
        Thread thb = new Thread(new TransferReentrant(transferAmount, a, b), "B");
        tha.start();
        thb.start();
    }
}
