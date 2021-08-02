/* ECE 2035 Homework 1-2

Your Name: Nishalini Shanmugan
Date: 9/4/19

This is the only file that should be modified for the C implementation
of Homework 1.

This program computes the Intersection over Union of two rectangles
as a percent:
                 Area(Intersection of R1 and R2) * 100
  IoU =    -----------------------------------------------------
           Area(R1) + Area(R2) - Area(Intersection of R1 and R2)

The answer will be specified as a percent: a number between 0 and 100.
For example, if the rectangles do not overlap, IoU = 0%.  If they are
at the same location and are the same height and width, IoU = 100%.
If they are the same area 30 and their area of overlap is 10, IoU =
20%.

Input: two bounding boxes, each specified as {Tx, Ty, Bx, By), where
	 (Tx, Ty) is the upper left corner point and
	 (Bx, By) is the lower right corner point.
       These are given in two global arrays R1 and R2.
Output: IoU (an integer, 0 <= IoU < 100).

In images, the origin (0,0) is located at the left uppermost pixel,
x increases to the right and y increases downward.
So in our bounding box representation, it will always be true that:
         Tx < Bx and Ty < By.

Assume images are 640x480 and bounding boxes fit within these bounds and
are always of size at least 1x1.

IoU should be specified as an integer (only the whole part of the division),
i.e., round down to the nearest whole number between 0 and 100 inclusive.

FOR FULL CREDIT (on all assignments in this class), BE SURE TO TRY
MULTIPLE TEST CASES and DOCUMENT YOUR CODE.
*/

#include <stdio.h>
#include <stdlib.h>

//DO NOT change the following declaration (you may change the initial value).
// Bounding box: {Tx, Ty, Bx, By}
int R1[] = {5, 5, 10, 20};
int R2[] = {15, 5, 20, 20};
int IoU;

/*
For the grading scripts to run correctly, the above declarations
must be the first lines of code in this file (for this homework
assignment only).  Under penalty of grade point loss, do not change
these lines, except to replace the initial values while you are testing
your code.  

Also, do not include any additional libraries.
 */

int main() {

  // #
  int width1, width2, height1, height2, interwidth, interheight, AreaR1, AreaR2, AreaInter;

  //The intersection of the width is min(Bx1,Bx2)-max(Tx1,Tx2) 
  //width1 is the min(Bx1,Bx2)
  if (R1[2] < R2[2])
    width1 = R1[2];
  else
    width1 = R2[2];
  //Width2 is the max(Tx1,Tx2)
  if (R1[0] > R2[0])
    width2 = R1[0];
  else 
    width2 = R2[0];
  //The intersection of the width is min(By1,By2)-max(Ty1,Ty2)
  //Height1 is the min(By1,By2)
  if (R1[3] < R2[3])
    height1 = R1[3];
  else
    height1 = R2[3];
  //Height2 is the min(Ty1,Ty2)
  if (R1[1] > R2[1])
    height2 = R1[1];
  else 
    height2 = R2[1];

  //The intersection of the width is the interwidth
  //The intersection of the height is the interheight
  interwidth = width1 - width2;
  interheight = height1 - height2;

  AreaInter = interwidth*interheight;

  AreaR1 = (R1[3]-R1[1])*(R1[2]-R1[0]);
  AreaR2 = (R2[3]-R2[1])*(R2[2]-R2[0]);

IoU = (AreaInter*100)/(AreaR1+AreaR2-AreaInter);

  printf("Intersection over Union: %d%%\n", IoU);
  return 0;
}



