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
public class AccountReentrant {

    public final ReentrantLock locker = new ReentrantLock();

    private int balance;
    private int accountSerial = 0;

    public AccountReentrant(int initialDeposit, int accountSerial) {
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
        // synchronized (this) {
        try {
            locker.lock();
            if (balance >= amount) {
                balance = balance - amount;
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
        } finally {
            locker.unlock();
        }
        return false;
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

    /**
     * Idea for a deadlock prevention.Compare the accounts and always lock the
     * `smaller` account first. This realtes to having one philosopher taking
     * its sticks in reverse order.
     *
     * @param dest
     * @param amount
     * @return
     */
    public boolean transferWithOutDeadLock(AccountReentrant dest, int amount) {
        if (dest.getAccountSerial() < this.getAccountSerial()) {  // This comparison does not work yet, correct it.

            if (!dest.locker.isLocked()) {
                dest.locker.lock();
                try {
                    if (!locker.isLocked()) {
                        try {
                            if (withdraw(amount)) {
                                dest.deposit(amount);
                                return true;
                            } else {
                                return false;
                            }
                        } catch (Exception e) {
                        } finally {
                            locker.unlock();
                        }
                    }
                } catch (Exception e) {
                } finally {
                    dest.locker.unlock();
                }
                //if()
            }
        } else {
            try {
                locker.lock();
                synchronized (dest) {
                    if (withdraw(amount)) {
                        dest.deposit(amount);
                        return true;
                    } else {
                        return false;
                    }
                }
            } catch (Exception e) {
            } finally {
                locker.unlock();
            }

        }
        return false;
    }

}
