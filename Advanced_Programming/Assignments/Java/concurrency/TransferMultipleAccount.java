/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.OOP.concurrency;

import java.util.concurrent.locks.ReentrantLock;

/**
 *
 * @author Faiz Ahmed
 */
public class TransferMultipleAccount implements Runnable {

    Account source1;
    Account source2;
    Account destinaiton;
    int amountToTranser;
   // final ReentrantLock locker = new ReentrantLock();

    public TransferMultipleAccount(int amount, Account destinaiton, Account account1, Account account2) {
        this.source1 = account1;
        this.source2 = account2;
        this.destinaiton = destinaiton;
        this.amountToTranser = amount;
    }

    @Override
    public void run() {
        //  for (int i = 1; i <= this.amountToTranser; i++) {
        // this.source.transfer(this.destinaiton, 1);
        //  collectedTransfer(1, destinaiton, source1, source2);
        // }
        collectedTransfer(amountToTranser, destinaiton, source1, source2);
        System.out.println("Balance of " + Thread.currentThread().getName() + " " + this.destinaiton.getBalance());
    }

    public boolean collectedTransfer(int amount, Account dest, Account account1, Account account2) {
        if (account1.getBalance() >= amount && account2.getBalance() >= amount) {
            if (account1.getAccountSerial() < account2.getAccountSerial()) {
                try {
                   // locker.lock();
                    boolean t1 = dest.transferWithoutLock(account1, amount);
                    if (t1) {
                        boolean t2 = dest.transferWithoutLock(account2, amount);
                        return t2;
                    }
                } catch (Exception e) {
                } finally {
                   // locker.unlock();
                }
            } else {
                try {
                   // locker.lock();
                    boolean t1 = dest.transferWithoutLock(account2, amount);
                    if (t1) {
                        boolean t2 = dest.transferWithoutLock(account1, amount);
                        return t2;
                    }
                } catch (Exception e) {
                } finally {
                  //  locker.unlock();
                }
            }
        }
        return false;
    }

    public static void main(String[] args) {
        int initAmount = 10000000;
        int transferAmount = 100;
        Account a = new Account(initAmount, 1);
        Account b = new Account(initAmount, 2);
        Account c = new Account(initAmount, 3);

        Thread tha = new Thread(new TransferMultipleAccount(transferAmount, a, b, c), "A");
        Thread thb = new Thread(new TransferMultipleAccount(transferAmount, b, c, a), "B");
        // Thread thc = new Thread(new TransferMultipleAccount(transferAmount, c, b, a), "C");
        tha.start();
        thb.start();
        // thc.start();
    }
}
