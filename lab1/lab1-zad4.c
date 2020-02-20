#include <stdio.h>

#define E 2.718281828459

int main()
{
    printf("Unstable algorithm y_(n+1) = e - (n+1)y_n:\n");
    int i = 1;
    float y = 1.0;
    while(i <= 20)
    {
        printf("n = %d: %f\n", i, y);
        y = E - ((i + 1) * y);
        i++;
    }

    printf("\n\nStable algorithm:\n");
    printf("Assuming y_20 = 0\n");
    printf("y_n = (e - y_(n+1)) / (n+1) \n\n");

    i = 20;
    y = 0.0;
    while(i >= 0)
    {
        printf("n = %d: %f\n", i, y);
        y = (E - y) / i;
        i--;
    }

    return 0;
}
