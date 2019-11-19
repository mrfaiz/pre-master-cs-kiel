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
public class TransferMultipleAccount implements Runnable {

    Account source1;
    Account source2;
    Account destinaiton;
    int amountToTranser;

    public TransferMultipleAccount(int amount, Account destinaiton, Account account1, Account account2) {
        this.source1 = account1;
        this.source2 = account2;
        this.destinaiton = destinaiton;
        this.amountToTranser = amount;
    }

    @Override
    public void run() {
//        for (int i = 1; i <= this.amountToTranser; i++) {
//            collectedTransfer(1, destinaiton, source1, source2);
//        }
 collectedTransfer(amountToTranser, destinaiton, source1, source2);
        System.out.println("Balance of " + Thread.currentThread().getName() + " " + this.destinaiton.getBalance());
    }

    private boolean collectedTransfer(int balance, Account destination, Account source1, Account source2) {
        if (source1.getBalance() + source2.getBalance() >= balance) {
            if (destination.getAccountSerial() < source1.getAccountSerial() && source1.getAccountSerial() < source2.getAccountSerial()) {
                synchronized (destination) {
                    synchronized (source1) {
                        synchronized (source2) {
                            if (source1.withdraw(balance)) {
                                if (source2.withdraw(balance)) {
                                    destination.deposit((balance + balance));
                                    return true;
                                } else {
                                    source1.deposit(balance);
                                }
                            }
                        }
                    }
                }
            } else if (destination.getAccountSerial() < source2.getAccountSerial() && source2.getAccountSerial() < source1.getAccountSerial()) {
                synchronized (destination) {
                    synchronized (source2) {
                        synchronized (source1) {
                            if (source1.withdraw(balance)) {
                                if (source2.withdraw(balance)) {
                                    destination.deposit((balance + balance));
                                    return true;
                                } else {
                                    source1.deposit(balance);
                                }
                            }
                        }
                    }
                }
            } else if (source1.getAccountSerial() < destination.getAccountSerial() && destination.getAccountSerial() < source2.getAccountSerial()) {
                synchronized (source1) {
                    synchronized (destination) {
                        synchronized (source2) {
                            if (source1.withdraw(balance)) {
                                if (source2.withdraw(balance)) {
                                    destination.deposit((balance + balance));
                                    return true;
                                } else {
                                    source1.deposit(balance);
                                }
                            }
                        }
                    }
                }
            } else if (source1.getAccountSerial() < source2.getAccountSerial() && source1.getAccountSerial() < destination.getAccountSerial()) {
                synchronized (source1) {
                    synchronized (source2) {
                        synchronized (destination) {
                            if (source1.withdraw(balance)) {
                                if (source2.withdraw(balance)) {
                                    destination.deposit((balance + balance));
                                    return true;
                                } else {
                                    source1.deposit(balance);
                                }
                            }
                        }
                    }
                }
            } else if (source2.getAccountSerial() < source1.getAccountSerial() && source1.getAccountSerial() < destination.getAccountSerial()) {
                synchronized (source2) {
                    synchronized (source1) {
                        synchronized (destination) {
                            if (source1.withdraw(balance)) {
                                if (source2.withdraw(balance)) {
                                    destination.deposit((balance + balance));
                                    return true;
                                } else {
                                    source1.deposit(balance);
                                }
                            }
                        }
                    }
                }
            } else if (source2.getAccountSerial() < destination.getAccountSerial() && destination.getAccountSerial() < source1.getAccountSerial()) {
                synchronized (source2) {
                    synchronized (destination) {
                        synchronized (source1) {
                            if (source1.withdraw(balance)) {
                                if (source2.withdraw(balance)) {
                                    destination.deposit((balance + balance));
                                    return true;
                                } else {
                                    source1.deposit(balance);
                                }
                            }
                        }
                    }
                }
            }
        }
//        if (source1.getBalance() >= balance && source2.getBalance() >= balance) {
//            if (source1.getAccountSerial() < source2.getAccountSerial()) {
//                //  if(source1.getAccountSerial()<destination.){}
////                synchronized (source1) {
////                    synchronized (source2) {
////                        synchronized (destination) {
////                            if (source1.withdraw(balance)) {
////                                if (source2.withdraw(balance)) {
////                                    destination.deposit((balance + balance));
////                                    return true;
////                                } else {
////                                    source1.deposit(balance);
////                                }
////                            }
////                        }
////                    }
////                }
//            } else {
//                synchronized (source2) {
//                    synchronized (source1) {
//                        synchronized (destination) {
//                            if (source1.withdraw(balance)) {
//                                if (source2.withdraw(balance)) {
//                                    destination.deposit((balance + balance));
//                                    return true;
//                                } else {
//                                    source1.deposit(balance);
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
        return false;
    }

    public static void main(String[] args) {
        int initAmount = 10000000;
        int transferAmount = 500000;
        Account a = new Account(initAmount, 1);
        Account b = new Account(initAmount, 2);
        Account c = new Account(initAmount, 3);

        Thread tha = new Thread(new TransferMultipleAccount(transferAmount, a, b, c), "A");
        Thread thb = new Thread(new TransferMultipleAccount(transferAmount, a, c, b), "A");
        tha.start();
        thb.start();
    }
}
