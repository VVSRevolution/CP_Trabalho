#include <stdio.h>

int main(){

    long long int *primo;
    cudaMallocManaged(&primo, 100000*sizeof(long long int)); 
    


    
    primo[0] = 2;
    primo[1] = 3;
    primo[2] = 5;
    primo[3] = 7;

    printf("%lld ", primo[0] );
    
}