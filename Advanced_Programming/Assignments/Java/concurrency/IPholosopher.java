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
public interface IPholosopher {

    void takeSticks();

    void putSticks();

    void eat();

    void think();

    void print(String state);
}