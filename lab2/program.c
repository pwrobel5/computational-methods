#include <stdlib.h>
#include <time.h>
#include <stdio.h>

#include <gsl/gsl_blas.h>
#include <gsl/gsl_vector.h>
#include <gsl/gsl_matrix.h>

#define NUMBER_OF_MEASUREMENTS 10

int main()
{
    srand(time(NULL));
    char* csv_name = "gsl_blas_out.csv\0";
    FILE* csv_output = fopen(csv_name, "w");

    if(csv_output == NULL)
    {
        printf("Error with opening csv file!\n");
        return 1;
    }

    fprintf(csv_output, "Size;Measure;Time_1st_level;Time_2nd_level\n");

    for(int size = 1; size <= 5000; size += 50)
    {
        gsl_vector* x = gsl_vector_alloc(size);
        gsl_vector* y = gsl_vector_alloc(size);
        gsl_matrix* A = gsl_matrix_alloc(size, size);

        double alpha = 0.0;
        double beta = 0.0;

        double result = 0;
        clock_t start_time = 0;
        clock_t end_time = 0;

        for(int measure = 0; measure < NUMBER_OF_MEASUREMENTS; measure++)
        {
            for(int i = 0; i < size; i++)
            {
                gsl_vector_set(x, i, (double) ((rand() % 100) / 1.5));
                gsl_vector_set(y, i, (double) ((rand() % 100) / 1.5));

                alpha = (double) ((rand() % 100) / 1.5);
                beta = (double) ((rand() % 100) / 1.5);

                for(int j = 0; j < size; j++)
                {
                    gsl_matrix_set(A, i, j, (double) ((rand() % 100) / 1.5));
                }
            }

            start_time = clock();
            gsl_blas_ddot(x, y, &result);
            end_time = clock();

            double taken_time_vec = 1000 * ((double) (end_time - start_time)) / CLOCKS_PER_SEC; // 1000 to have result in ms
            printf("Scalar product of two vectors: \t");
            printf("size: %d, measure: %d time: %f ms\n", size, measure, taken_time_vec);

            start_time = clock();
            gsl_blas_dgemv(CblasNoTrans, alpha, A, x, beta, y);
            end_time = clock();

            double taken_time_matrix = 1000 * ((double) (end_time - start_time)) / CLOCKS_PER_SEC; // 1000 to have result in ms
            printf("Product of matrix and vector: \t");
            printf("size: %d, measure: %d time: %f ms\n", size, measure, taken_time_matrix);

            fprintf(csv_output, "%d;%d;%f;%f\n", size, measure, taken_time_vec, taken_time_matrix);
        }
    }

    fclose(csv_output);

    return 0;
}
