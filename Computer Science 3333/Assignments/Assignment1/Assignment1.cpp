#include <opencv2/opencv.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv/cvaux.h>

IplImage* doPyrDown(IplImage* in) {
	//checks if the image resolutions are divisble by 2
    assert(in->width%2 == 0 && in->height%2 == 0);
    //create an image that will hold the value of the next level of the Gaussian pyramid
    IplImage* out = cvCreateImage(cvSize( in->width/2, in->height/2 ), in->depth, in->nChannels);
    //performs the Gaussian pyramid down operation
    cvPyrDown(in, out);
    return(out);
};

int main( int argc, char** argv ) {
	//creates a set of image objects that can be used to perform operations
    IplImage *img1, *img2, *img3, *img4;

    //loads the two images you'd like to compare
    img1 = cvLoadImage(argv[1]);
    img2 = cvLoadImage(argv[2]);

    //generates a level four Gaussian pyramid for the input images
    for (int i = 0; i < 3; i++){
        img1 = doPyrDown(img1);
        img2 = doPyrDown(img2);
    }

    img3 = cvCreateImage(cvGetSize(img1), img1->depth, 1);
    img4 = cvCreateImage(cvGetSize(img2), img2->depth, 1);
    
    //generates the grayscaled images
    cvCvtColor(img1, img3 ,CV_BGR2GRAY);
    cvCvtColor(img2, img4 ,CV_BGR2GRAY);

    //computes the absolute different image from the grayscaled images
    cvAbsDiff(img3, img4, img3);
    //computes the binary image
    cvThreshold(img3, img3, 75, 255, 0);

    img1 = cvLoadImage(argv[1]);
    img2 = cvCreateImage(cvGetSize(img1), img1->depth, 1);
    img4 = cvCreateImage(cvGetSize(img1), img1->depth, img1->nChannels);

    //converte the image size back to the resolution of the input images
    cvResize(img3, img2, CV_INTER_NN);
    //dilate the image
    cvDilate(img2, img2, NULL, 25);
    //copy the solution into img4 and apply the mask from img2
    cvCopy(img1, img4, img2);

    cvNamedWindow("Result") ;
    cvShowImage( "Result", img4 );
    cvWaitKey(0);

    //garbage collecting
    cvReleaseImage(&img1);
    cvReleaseImage(&img2);
    cvReleaseImage(&img3);
    cvReleaseImage(&img4);
    cvDestroyWindow("Result") ;
}
