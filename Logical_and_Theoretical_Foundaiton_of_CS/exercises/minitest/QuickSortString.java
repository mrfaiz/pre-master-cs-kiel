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
public class QuickSortString {

    private void swap(String[] a, int index, int index2) {
        String temp = a[index];
        a[index] = a[index2];
        a[index2] = temp;
    }

    public String[] toArray(String inputstirng) {
        return inputstirng.split(" ");
    }

    public int partition(String[] a, int low, int high) {
        String pivot = a[high];
        int i = low - 1;
        // System.out.println("i=" + i);
        for (int j = low; j < high; j++) {
            if (a[j].compareTo(pivot) < 0) {
                i++;
                swap(a, i, j);
            }
        }
        swap(a, i + 1, high);
        return i + 1;
    }

    public void printArray(String arr[]) {
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

    void sort(String[] a, int low, int high) {
        if (low < high) {
            int pivot = partition(a, low, high);
            sort(a, low, pivot - 1);
            sort(a, pivot + 1, high);
        }
    }

    public static void main(String[] args) {
        System.out.println("Quick sort");
        QuickSortString qSort = new QuickSortString();
        String[] array = qSort.toArray("java FirstMiniTest Hello Kiel University Java Mini Test");
        //int[] a = qSort.makeRandomArray(10);
        // int[] a = {4, 1, 9, 5, 99, 200, 40, 11, 3};
        //System.out.println("Before Sort");
        qSort.printArray(array);
        System.out.println("After Sort");
        qSort.sort(array, 0, array.length - 1);
        qSort.printArray(array);
    }
}
