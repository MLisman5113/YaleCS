#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

#define NDAYS 12
#define FILEMAX 256
#define MONTHNAMEMAX 10
#define STREETNAMEMAX 12

typedef struct  {
    char month[MONTHNAMEMAX];
    int date;
    int th;
    int tl;
} ForecastRecord;

typedef struct {
    int b_number;
    char street[STREETNAMEMAX];
    int tank_cap;
    double fuel_amt;
    double k;
} CustomerRecord ;

int main()
{
    //declaring variables and input file parameters
   char file1 [FILEMAX];
   FILE *fp1=NULL;
   char file2 [FILEMAX];
   FILE *fp2=NULL;
   double td=0.; // temp diff
   int iDay=0, j=0, n_customers; // counters for each input file
   int doesCustNeedDelivery(CustomerRecord); // does customer need delivery function
   ForecastRecord forecast[NDAYS];
   CustomerRecord *customers=NULL;
   double gallons_delivered = 0., hdd=0.;
   int customers_served=0;
   void updateCustEstFuelInTank(CustomerRecord*, double, double);


    // allowing user to input forecast file
    printf("Enter the name of the forecast file (or drag it here):\n");
    scanf("%s", file1);
    printf("Data for the 12 forecast days were read in.\n\n");

     fp1 = fopen(file1, "r");

     if (fp1 == NULL)
     {
         printf("Error: could not open forecast file \n");
         return(1);
     }


    for(int iDay = 0; iDay < NDAYS; iDay++)
    {
        fscanf(fp1, "%s %d %d %d", &forecast[iDay].month, &forecast[iDay].date, &forecast[iDay].th, &forecast[iDay].tl);
    }

    fclose(fp1);

    
    printf("Enter the name of the customer file (or drag it here):\n");
    scanf("%s", file2);

    fp2 = fopen(file2, "r");

     if (fp2 == NULL)
     {
         printf("Error: could not open customer file \n" );
         return(1);
     }

        fscanf(fp2, "%d", &n_customers);

         customers = (CustomerRecord*) malloc(n_customers*sizeof(CustomerRecord));
           if (customers == NULL)
           {
               printf("Couldn't allocate memory for customers.\n");
               return 1;
           }

     for (j=0; j<n_customers; j++)
        {
            // Read the points into an array
               fscanf(fp2, "%d %s %d %lf %lf", &customers[j].b_number, customers[j].street,
                       &customers[j].tank_cap, &customers[j].fuel_amt, &customers[j].k);

        }


     fclose(fp2);

     printf("Data for %d customers were read in.\n", n_customers );
     printf("\n\nDELIVERY SCHEDULE\n");

     for(iDay=0; iDay<=NDAYS; iDay++)
     {
        printf("\n%s %d:\n", forecast[iDay].month, forecast[iDay].date);

        td=65.-(forecast[iDay].th+forecast[iDay].tl)/2.0;

        if (td>0.)
        {
            hdd=td;
        }
        else
        {
            hdd=0.;
        }


        for(j=0; j<=n_customers; j++)
          {
           
             if ((doesCustNeedDelivery(customers[j])) == 1)
             {
                 gallons_delivered = (customers[j].tank_cap)*0.7;
                 printf("%d  %s \t (%5.1lf gallons)\n", customers[j].b_number, customers[j].street, gallons_delivered);
                    customers[j].fuel_amt+=(gallons_delivered-(hdd*(customers[j].k)));
                 customers_served++;
             }

            else
             {
                gallons_delivered=0.;
                customers[j].fuel_amt-=(hdd*(customers[j].k));
             }          

          }

        if(customers_served==0)
        {
            printf("No fuel deliveries scheduled for this day.\n");
        }

     }

    printf("\nESTIMATED FUEL IN TANK AT END OF FORECAST PERIOD\n\n");

    for(j=0; j<=n_customers; j++)
    {
        printf("%d  %s \t %5.1lf \t gallons \n", customers[j].b_number, customers[j].street, customers[j].fuel_amt);
    }

    free(customers);
    customers = NULL;


    return 0;
}

int doesCustNeedDelivery(CustomerRecord x)
{

    if (x.fuel_amt < (double)(0.2*x.tank_cap))
    {
        return 1;
    }
    return 0;
}

void updateCustEstFuelInTank(CustomerRecord* x, double gallons_delivered, double hdd)
{

    x->fuel_amt += gallons_delivered - hdd*(x->k);

}


