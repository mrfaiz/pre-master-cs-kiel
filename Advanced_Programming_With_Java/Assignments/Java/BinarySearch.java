/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Faiz Ahmed
 */
public class BinarySearch {

    private int binarySearch(int[] a, int low, int high, int value) {
        if (high >= low) {
            int mid = 1 + (high - low) / 2;
            if (a[mid] == value) {
                return mid;
            }

            if (a[mid] > value) {
                return binarySearch(a, low, mid - 1, value);
            }

            if (a[mid] < value) {
                return binarySearch(a, mid + 1, high, value);
            }
        }
        return -1;
    }

    public static void main(String[] args) {
        int[] a = {55, 3, 59, 22, 11, 80, 45, 100, 43};
        QuickSort qSort = new QuickSort();
        qSort.sort(a, 0, a.length - 1);
        System.out.println("Sorted List");
        qSort.printArray(a);
        BinarySearch bs = new BinarySearch();
        int index = bs.binarySearch(a, 0, a.length, 43);
        if (index == -1) {
            System.out.println("Not found");
        } else {
            System.out.println("Index in sorted list=" + index);
        }
    }

}
