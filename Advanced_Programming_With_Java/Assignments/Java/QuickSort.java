/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.util.Random;

/**
 *
 * @author Faiz Ahmed
 */
public class QuickSort {

    private void swap(int[] a, int index, int index2) {
        int temp = a[index];
        a[index] = a[index2];
        a[index2] = temp;
    }

    public int partition(int[] a, int low, int high) {
        int pivot = a[high];
        int i = low - 1;
        for (int j = low; j < high; j++) {
            if (a[j] < pivot) {
                i++;
                swap(a, i, j);
            }
        }
        swap(a, i + 1, high);
        return i + 1;
    }

    public void printArray(int arr[]) {
        int n = arr.length;
        for (int i = 0; i < n; ++i) {
            System.out.print(arr[i] + " ");
        }
        System.out.println();
    }

    public int[] makeRandomArray(int size) {
        int[] a = new int[size];
        Random rn = new Random(0);
        for (int i = 0; i < size; i++) {
            a[i] = rn.nextInt();
        }
        return a;
    }

    void sort(int[] a, int low, int high) {
        if (low < high) {
            int pivot = partition(a, low, high);
            sort(a, low, pivot - 1);
            sort(a, pivot + 1, high);
        }
    }

    public static void main(String[] args) {
        System.out.println("Quick sort");
        QuickSort qSort = new QuickSort();
        int[] a = qSort.makeRandomArray(10);
        // int[] a={4,1,9,5,99,200,40,11,3};
        System.out.println("Before Sort");
        qSort.printArray(a);
        System.out.println("After Sort");
        qSort.sort(a, 0, a.length - 1);
        qSort.printArray(a);
    }
}
