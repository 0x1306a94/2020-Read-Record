//
//  main.m
//  03-08-lc40
//
//  Created by pmst on 2020/3/20.
//  Copyright © 2020 pmst. All rights reserved.
//

#import <Foundation/Foundation.h>


void merge(int *arr, int start,int mid,int end){
    int temp[10000] = {0};
    int k = 0;
    int i = start;
    int j = mid+1;
    while(i <=mid && j <=end){
        if(arr[i] < arr[j]){
            temp[k++] = arr[i++];
        } else {
            temp[k++] = arr[j++];
        }
    }

    while( i <= mid){
        temp[k++] = arr[i++];
    }

    while( j <= end){
        temp[k++] =  arr[j++];
    }

    k = 0;
    for(int i = start; i <= end;i++){
        arr[i] = temp[k++];
    }
}

void quickSort(int *arr,int start, int end){
    if (start >= end ){
        return;
    }
    int mid = (start + end)/2;
    quickSort(arr, start,mid);
    quickSort(arr, mid+1, end);
    merge(arr, start, mid, end);
}

int* getLeastNumbers(int* arr, int arrSize, int k, int* returnSize){
    quickSort(arr, 0, arrSize-1);
    for(int i = 0;i < arrSize;i++)printf("%d ",arr[i]);
    int *ans = (int *)malloc(sizeof(int) * k);
    memset(ans,0,k);
    *returnSize = k;
    return ans;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        int cases[3] = {3,2,4};
        int returnSize = 0;
        getLeastNumbers(cases, 3, 2, &returnSize);
        printf("hello world");
    }
    return 0;
}
