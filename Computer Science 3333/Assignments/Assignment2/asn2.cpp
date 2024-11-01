#include <opencv2/opencv.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv/cvaux.h>
#include <math.h>

#define NSZIE 31
#define PYR_SCALE 0.5
#define LEVELS 3
#define WINSIZE 21
#define ITERATIONS 3
#define POLY_N 21
#define POLY_SIGMA 1.1

/**********************************************************************
main.cpp
Name: Zaid Albirawi
id: zalbiraw
#: 250626065
date: Oct 26, 2o14

main.cpp takes in two images, calculates the optical flow of the first
image, and then trys to generate an estimate second image. 

Parameters:
commad line arguments, this program needs 2 images

img1    INPUT   an image, imported into a matrix object
img2    INPUT   an image, imported into a matrix object

**********************************************************************/

int main(int argc, char** argv) {
    cv::Mat img1, img2, flow, estm;
    int x, y, i, j, flowX, flowY, newPixel, n, fPixel, posFix = (NSZIE-1)/2;
    double avg, stdiv;

    //imports the images into matrix objects
    img1 = cv::imread(argv[1], CV_LOAD_IMAGE_GRAYSCALE);
    img2 = cv::imread(argv[2], CV_LOAD_IMAGE_GRAYSCALE);
    estm = cv::imread(argv[2], CV_LOAD_IMAGE_GRAYSCALE);

    //calculates the optical flow for img1 going to img2
    calcOpticalFlowFarneback(img1, img2, flow, PYR_SCALE, LEVELS, WINSIZE, ITERATIONS, POLY_N, POLY_SIGMA, cv::OPTFLOW_USE_INITIAL_FLOW);

    //iterates through the x, y coordinates of the img to calculate the estm image
    for (y = posFix; y < flow.rows - posFix; y++)
    {
        for (x = posFix; x < flow.cols - posFix; x++) 
        {   
            newPixel = 0;
            n = 0;
            for (i = -posFix; i <= posFix; i++) 
            {
                for (j = -posFix; j <= posFix; j++) 
                {
                    const cv::Point2f& flowPixel = flow.at<cv::Point2f>(y + j, x + i);
                    flowX = cvRound(x + i + flowPixel.x);
                    flowY = cvRound(y + j + flowPixel.y);
                    if (flowX == x && flowY == y) 
                    {
                        //if the the pixel (k+u, v+l) contributes to (i, j) then sums the 
                        //value of that pixel for the linear contribution calculation
                        newPixel += (int)img1.at<uchar>(y + j, x + i);
                        n++;
                    }
                }
            }
            //calculates the linear contribution
            if (n != 0) 
                estm.at<uchar>(y, x) = newPixel/n;
            else 
                estm.at<uchar>(y, x) = 0;
        }
    }

    //Finds the average for the difference between estm and img2
    avg = 0; n = 0; 
    for (y = 0; y < img2.rows; y++)
    {
        for (x = 0; x < img2.cols; x++)
        {
            if ((fPixel = estm.at<uchar>(y, x)) != 0) 
            {
                avg += fPixel - img2.at<uchar>(y, x);
                n++;
            }
        }
    }
    avg = avg/n;

    //computes the standard deviation
    stdiv = 0; 
    for (y = 0; y < img2.rows; y++)
    {
        for (x = 0; x < img2.cols; x++)
        {
            if ((fPixel = estm.at<uchar>(y, x)) != 0)
                stdiv += pow((fPixel - img2.at<uchar>(y, x)) - avg, 2);
        }
    }
    stdiv = sqrt(stdiv/n);

    cv::namedWindow( "Display window", CV_WINDOW_AUTOSIZE );// Create a window for display.
    cv::imshow( "Display window", estm );

    std::cout << "Difference Average: " << avg << ", Standard Deviation: " << stdiv << "\n";
    cvWaitKey(0);
}