#include <stdlib.h>
#include <stdio.h>

#define TAM 4

void fill_matrix(int* matrix) {
    int val = 0;
    for (int i = 0; i < TAM; i++)
        for (int j = 0; j < TAM; j++) {
            matrix[TAM*i+j] = val; 
            val++;
        } 
}

void print_matrix(int* matrix) {
    for (int i = 0; i < TAM; i++) {
        for (int j = 0; j < TAM; j++)
            printf("%4d ", matrix[TAM*i+j]);
        printf("\n");
    }
}

void multiply_matrixes(int* a, int* b, int* dest) {
    int sum = 0;
    for (int i = 0; i < TAM; i++) {
        for (int j = 0; j < TAM; j++) {
            for (int k = 0; k < TAM; k++) {
                sum += a[TAM*i+k] * b[TAM*k+j];
            }
            dest[TAM*i+j] = sum;
            sum = 0;
        }
    }
}

int main() {
    int* product = malloc(TAM*TAM*sizeof(int));
    int* a = malloc(TAM*TAM*sizeof(int));
    int* b = malloc(TAM*TAM*sizeof(int));
    
    fill_matrix(a);
    fill_matrix(b);
    
    print_matrix(a);
    printf("\n");
    print_matrix(b);
    printf("\n");

    multiply_matrixes(a, b, product);
    print_matrix(product);

    return 0;
}
