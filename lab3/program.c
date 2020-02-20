#include <stdlib.h>
#include <time.h>
#include <stdio.h>

#include <gsl/gsl_blas.h>
#include <gsl/gsl_vector.h>
#include <gsl/gsl_matrix.h>

#define NUMBER_OF_MEASUREMENTS 10

gsl_matrix* naive_multiplication(gsl_matrix* A, gsl_matrix* B, int size)
{
    gsl_matrix* C = gsl_matrix_alloc(size, size);
    gsl_matrix_set_all(C, 0.0);

    for(int i = 0; i < size; i++)
    {
        for(int j = 0; j < size; j++)
        {
            for(int k = 0; k < size; k++)
            {
                double new_val = gsl_matrix_get(C, i, j) + gsl_matrix_get(A, i, k) * gsl_matrix_get(B, k, j);
                gsl_matrix_set(C, i, j, new_val);
            }
        }
    }

    return C;
}

gsl_matrix* better_multiplication(gsl_matrix* A, gsl_matrix* B, int size)
{
    gsl_matrix* C = gsl_matrix_alloc(size, size);
    gsl_matrix_set_all(C, 0.0);

    for(int i = 0; i < size; i++)
    {
        for(int k = 0; k < size; k++)
        {
            for(int j = 0; j < size; j++)
            {
                double new_val = gsl_matrix_get(C, i, j) + gsl_matrix_get(A, i, k) * gsl_matrix_get(B, k, j);
                gsl_matrix_set(C, i, j, new_val);
            }
        }
    }

    return C;
}

int main()
{
    srand(time(NULL));
    char* csv_name = "matrices_out_opt3.csv\0";
    FILE* csv_output = fopen(csv_name, "w");

    if(csv_output == NULL)
    {
        printf("Error with opening csv file!\n");
        return 1;
    }

    fprintf(csv_output, "Size;Measure;Time_naive;Time_better;Time_blas\n");

    for(int size = 2; size <= 350; size += 10)
    {
        gsl_matrix* A = gsl_matrix_alloc(size, size);
        gsl_matrix* B = gsl_matrix_alloc(size, size);
        gsl_matrix* D = gsl_matrix_alloc(size, size); // for adding in BLAS

        clock_t start_time = 0;
        clock_t end_time = 0;

        for(int measure = 0; measure < NUMBER_OF_MEASUREMENTS; measure++)
        {
            for(int i = 0; i < size; i++)
            {
                for(int j = 0; j < size; j++)
                {
                    gsl_matrix_set(A, i, j, (double) ((rand() % 100) / 1.5));
                    gsl_matrix_set(B, i, j, (double) ((rand() % 100) / 1.5));
                    gsl_matrix_set(D, i, j, (double) ((rand() % 100) / 1.5));
                }
            }

            start_time = clock();
            gsl_matrix* C = naive_multiplication(A, B, size);
            end_time = clock();
            gsl_matrix_free(C);

            double naive_time = 1000 * ((double) (end_time - start_time)) / CLOCKS_PER_SEC;
            printf("Naive multiplication: \t");
            printf("size: %d, measure: %d time: %f ms\n", size, measure, naive_time);

            start_time = clock();
            C = better_multiplication(A, B, size);
            end_time = clock();
            gsl_matrix_free(C);

            double better_time = 1000 * ((double) (end_time - start_time)) / CLOCKS_PER_SEC;
            printf("Better multiplication: \t");
            printf("size: %d, measure: %d time: %f ms\n", size, measure, better_time);

            
            start_time = clock();
            gsl_blas_dgemm(CblasNoTrans, CblasNoTrans, 1.0, A, B, 1.0, D);
            end_time = clock();

            double blas_time = 1000 * ((double) (end_time - start_time)) / CLOCKS_PER_SEC;
            printf("BLAS multiplication: \t");
            printf("size: %d, measure: %d time: %f ms\n", size, measure, blas_time);

            fprintf(csv_output, "%d;%d;%f;%f;%f\n", size, measure, naive_time, better_time, blas_time);
        }

        gsl_matrix_free(A);
        gsl_matrix_free(B);
        gsl_matrix_free(D);
    }
    fclose(csv_output);

    return 0;
}