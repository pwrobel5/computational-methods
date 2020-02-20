#include <stdio.h>
#include <gsl/gsl_ieee_utils.h>

#define EPS 1E-150

int main()
{
  float start_value = 1.4;

  while(start_value > EPS)
  {
    gsl_ieee_printf_float(&start_value);
    printf("\n");
    start_value /= 2.0;
  }

  return 0;
}