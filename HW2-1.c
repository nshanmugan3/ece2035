/*  ECE 2035 Homework 2-1:  When Harry Met Sally

Your Name: Nishalini Shanmugan 
Date:9/12/13

This program finds the earliest year in which Harry and Sally live in the same
city.

This is the only file that should be modified for the C implementation
of Homework 2.

FOR FULL CREDIT (on all assignments in this class), BE SURE TO TRY
MULTIPLE TEST CASES and DOCUMENT YOUR CODE.

*/

#include <stdio.h>
#include <stdlib.h>

#define DEBUG 1 // RESET THIS TO 0 BEFORE SUBMITTING YOUR CODE

/* City IDs used in timelines. */
enum Cities{ London, Boston, Paris, Atlanta, Miami, 
             Tokyo, Metz, Seoul, Toronto, Austin };
int  Load_Mem(char *, int *, int *);
void Print_Timelines(int *, int *);
int main(int argc, char *argv[]) {
   int	HarryTimeline[10];
   int	SallyTimeline[10];
   int	NumNums, Year=0;


   if (argc != 2) {
     printf("usage: ./HW2-1 valuefile\n");
     exit(1);
   }
   NumNums = Load_Mem(argv[1], HarryTimeline, SallyTimeline);
   if (NumNums != 20) {
     printf("valuefiles must contain 20 entries\n");
     exit(1);
   }
   if (DEBUG)
     Print_Timelines(HarryTimeline, SallyTimeline);

   /* Your program goes here */

   int Harry_start_year = 1990;                                                                               // Set Harry's start year to 1990              
   int Harry_end_year = 1990;                                                                                 // Set Harry's end year to 1990
   int Sally_start_year = 1990;                                                                               // Set Sally's start year to 1990
   int Sally_end_year = 1990;                                                                                 // Set Sally's end year to 1990
   for(int i=0;i<10;i+=2){                                                                                    
      Harry_start_year = Harry_end_year;                                                                      //Harry's start year begins at 1990 and is incremented by 2 until it reaches 2019
      Harry_end_year += HarryTimeline[i];                                                                     //Harry's end year will be added to Harry's Timeline
        
        int Sally_start_year = 1990;                                                                          //In order to prevent Sally's start year from incrementing past 2019, Sally's start year has to be reset to 1990 
        int Sally_end_year = 1990;                                                                            //Sally's end year is reset to 1990
        for (int j=0;j<10;j+=2){
            Sally_start_year = Sally_end_year;                                                                //Sally's start year is equal to the past end_year
            Sally_end_year += SallyTimeline[j];                                                               //Sally's end year is added to Sally's timeline
            if (HarryTimeline[i+1] == SallyTimeline[j+1]){                                                    //Only look at the cases where the city codes are the same for Harry and Sally
              if ((Harry_start_year <= Sally_start_year) && (Sally_start_year < Harry_end_year)){             //If the following conditions are true, then select Sally's start year
                Year = Sally_start_year;
              }
              if ((Sally_start_year <= Harry_start_year) && (Harry_start_year < Sally_end_year)){             //If the following conditions are true, then select Harry's start year
                Year = Harry_start_year;
                break;                                                                                         //The first time this condition is met, break
              }             
            }
        }

        if (Year != 0)                                                                                         //If the Year is not equal to 0 break from the outer for-loop and print the result
          break;          
    }
    printf("Earliest year in which both lived in the same city: %d\n", Year);
    
exit(0);
}

/* This routine loads in up to 20 newline delimited integers from
a named file in the local directory. The values are placed in the
passed integer array. The number of input integers is returned. */

int Load_Mem(char *InputFileName, int IntArray1[], int IntArray2[]) {
   int	N, Addr, Value, NumVals;
   FILE	*FP;

   FP = fopen(InputFileName, "r");
   if (FP == NULL) {
     printf("%s could not be opened; check the filename\n", InputFileName);
     return 0;
   } else {
     for (N=0; N < 20; N++) {
       NumVals = fscanf(FP, "%d: %d", &Addr, &Value);
       if (NumVals == 2)
	 if (N < 10)
	   IntArray1[N] = Value;
	 else
	   IntArray2[N-10] = Value;
       else
	 break;
     }
     fclose(FP);
     return N;
   }
}

/* Colors used to display timelines.
https://en.wikipedia.org/wiki/ANSI_escape_code#Colors */

const char *colors[10] = {"\x1b[30;41m", // red
			  "\x1b[30;42m", // green
			  "\x1b[30;43m", // yellow
			  "\x1b[30;44m", // blue
			  "\x1b[30;45m", // magenta
			  "\x1b[30;46m", // cyan (light blue)
			  "\x1b[30;47m", // white bkgd
			  "\x1b[30;103m", // bright yellow
			  "\x1b[30;104m", // bright blue
			  "\x1b[30;106m"}; // bright cyan

#define RESET      "\x1b[0m"

void Print_Years(){
  int i;
  printf("  ");
  for (i=90; i<120; i++){
    printf("%3d", i%100);
  }
  printf("\n");
}

void Print_Timeline(int Timeline[]){
  int j, duration, city;
  int scale = 3;
  char interval[6];
  for (j=0; j<10; j=j+2){
    duration = Timeline[j];
    city     = Timeline[j+1];
    snprintf(interval, sizeof(interval), "%%%dd", duration*scale);
    printf("%s", colors[city]); // start highlighting in city's color
    printf(interval, city);
  }
  printf(RESET); // stop highlighting
  printf("\n");
}


void Print_Timelines(int HarryTimeline[], int SallyTimeline[]) {
  Print_Years();
  printf("H: ");

  Print_Timeline(HarryTimeline);

  printf("S: ");
  Print_Timeline(SallyTimeline);
}

