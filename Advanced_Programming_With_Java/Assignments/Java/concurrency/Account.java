/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.OOP.concurrency;

import java.util.concurrent.Semaphore;

/**
 *
 * @author Faiz Ahmed
 */
public class Account {

    private int balance;
    private int accountSerial = 0;
    public Semaphore semaphore = new Semaphore(1);

    public Account(int initialDeposit, int accountSerial) {
        balance = initialDeposit;
        this.accountSerial = accountSerial;
    }

    public synchronized int getBalance() {
        return balance;
    }

    public int getAccountSerial() {
        return accountSerial;
    }

    public void setAccountSerial(int accountSerial) {
        this.accountSerial = accountSerial;
    }

    public synchronized void deposit(int amount) {
        balance += amount;
    }

    public boolean withdraw(int amount) {
        synchronized (this) {
            if (balance >= amount) {
                balance = balance - amount;
                return true;
            } else {
                return false;
            }
        }
    }

    /**
     * Attention, this code can produce a deadlock, if two (or more) threads
     * transfer money from/to a circle of accounts.
     *
     * @param dest
     * @param amount
     * @return
     */
    public boolean transferWithoutLock(Account dest, int amount) {
        if (withdraw(amount)) {
            dest.deposit(amount);
            return true;
        } else {
            return false;
        }
    }

    public boolean transfer(Account dest, int amount) {
        synchronized (dest) {
            synchronized (this) {
                if (withdraw(amount)) {
                    dest.deposit(amount);
                    return true;
                } else {
                    return false;
                }
            }
        }
    }

//    public boolean transferWithSemaphore(Account dest, int amount) throws InterruptedException {
//        boolean success = false;
//        if (dest.getAccountSerial() < this.getAccountSerial()) {  // This comparison does not work yet, correct it.
//            if (dest.semaphore.availablePermits() > 0) {
//                dest.semaphore.acquire();
//                if (this.semaphore.availablePermits() > 0) {
//                    this.semaphore.acquire();
//                    if (withdraw(amount)) {
//                        dest.deposit(amount);
//                        success = true;
//                    }
//                    this.semaphore.release();
//                }
//                dest.semaphore.release();
//            }
//        } else {
//            if (this.semaphore.availablePermits() > 0) {
//                this.semaphore.acquire();
//                if (dest.semaphore.availablePermits() > 0) {
//                    dest.semaphore.acquire();
//                    if (withdraw(amount)) {
//                        dest.deposit(amount);
//                        success = true;
//                    }
//                    dest.semaphore.release();
//                }
//                this.semaphore.release();
//            } else {
//                success = false;
//            }
//        }
//        return success;
//    }
//
    /**
     * Idea for a deadlock prevention.Compare the accounts and always lock the
     * `smaller` account first. This realtes to having one philosopher taking
     * its sticks in reverse order.
     *
     * @param dest
     * @param amount
     * @return
     */
    public boolean transferWithoutDeadLock(Account dest, int amount) {
        if (dest.getAccountSerial() < this.getAccountSerial()) {  // This comparison does not work yet, correct it.
            synchronized (dest) {
                synchronized (this) {
                    if (withdraw(amount)) {
                        dest.deposit(amount);
                        return true;
                    } else {
                        return false;
                    }
                }
            }
        } else {
            synchronized (this) {
                synchronized (dest) {
                    if (withdraw(amount)) {
                        dest.deposit(amount);
                        return true;
                    } else {
                        return false;
                    }
                }
            }
        }
    }
//
//    /**
//     * Idea for a deadlock prevention. Compare the accounts and always lock the
//     * `smaller` account first. This realtes to having one philosopher taking
//     * its sticks in reverse order.
//     *
//     * @param dest
//     * @param amount
//     * @return
//     */
//    public boolean transfer(int amount, Account dest) {
//        return this.transfer(amount, this, dest);
//    }
//

}
