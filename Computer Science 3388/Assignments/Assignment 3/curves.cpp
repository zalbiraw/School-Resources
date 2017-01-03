/*
* Name: Zaid Albirawi
* Student Number: 250626065
* Email: zalbiraw@uwo.ca
*
* curves.c calculates and the draws a spline based on the user selection.
*/

#include "curves.h"

#ifdef __APPLE__
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif
// #include <GL/glut.h>

#include <cmath>
#include <cassert>
#include <iostream>

/*
* Resolves the value of the qubic B based on the range based equations.
*
* double r  the r value to resolve the B value
*/
double curveOperations::evaluateCubicB(double r) const {
    double B;
    if (-2 <= r && r <= -1) {
        B = pow(2 + r, 3);
    } else if (-1 <= r && r <= 0) {
        B = 4 - 6 * pow(r, 2) - 3 * pow(r, 3);
    } else if (0 <= r && r <= 1) {
        B = 4 - 6 * pow(r, 2) + 3 * pow(r, 3);
    } else if (1 <= r && r <= 2) {
        B = pow(2 - r, 3);
    } else {
        B = 0;
    }
    return B / 6;
}

/*
* Resolves the value of the beta B based on the range based equations. The 
* constants S, and T which represent the skew and tension respectively.
*
* double r  the r value to resolve the B value.
*/
double curveOperations::evaluateBetaB(double r) const {
    double B;
    if (-2 <= r && r <= -1) {
        B = 2 * pow(2 + r, 3);
    } else if (-1 <= r && r <= 0) {
        B = ((T + 4 * S + 4 * pow(S, 2))
            - 6 * r * (1 - pow(S, 2))
            - 3 * pow(r, 2) * (2 + T + 2 * S)
            - 2 * pow(r, 3) * (1 + T + S + pow(S, 2)));
    } else if (0 <= r && r <= 1) {
        B = ((T + 4 * S + 4 * pow(S, 2))
            - 6 * r * (S - pow(S, 3))
            - 3 * pow(r, 2) * (T + 2 * pow(S, 2) + 2 * pow(S, 3))
            + 2 * pow(r, 3) * (T + S + pow(S, 2) + pow(S, 3)));
    } else if (1 <= r && r <= 2) {
        B = 2 * pow(S, 3) * pow(2 - r, 3);
    } else {
        B = 0;
    }
    return B / (T + 2 * pow(S, 3) + 4 * pow(S, 2) + 4 * S + 2);
}

/*
* evaluateClosed adds a point to the end of the control points vector to close
* the polygon, it also adds phantom points to the sum so that the curve goes 
* through the origin. evaluateClosed first gets the summation result from a 
* beta operation and then adds the closing point(the first point) and the 
* phantom points to that sum.
*
* double u  a value between [0, 1] that will be used to calculate r for B.
*/
Vector2D curveOperations::evaluateClosed(double u) const {
    //n = n + 1 because we added another point to vector of control points.
    int n = (controlPoints.size() - 1) + 1;
    Vector2D P = evaluateBspline(BETA_CLOSED, u);

    //Evaluates the value of the first point to the control points as the last
    //point and adds it to the sum.
    P += controlPoints[0] * evaluateBetaB(n * u - n);

    //Evaluates the phantom points and adds them to the sum.
    //pStart = (2P0 - P1) * B(nu - i), i = -1
    P += (2 * controlPoints[0] - controlPoints[1])
                * evaluateBetaB(n * u - (-1));
    //pEnd = (2Pn - Pn-1) * B(nu - i), i = n + 1
    P += (2 * controlPoints[0] - controlPoints[n - 1]) 
                * evaluateBetaB(n * u - (n + 1));

    return P;
}

/*
* evaluatePhantom adds phantom points to the sum so that the curve goes 
* through the origin. evaluatePhantom first gets the summation result from a 
* cubic operation and then adds the closing point and the phantom points
* to that sum.
*
* double u  a value between [0, 1] that will be used to calculate r for B.
*/
Vector2D curveOperations::evaluatePhantom(double u) const {
    int n = controlPoints.size() - 1;
    Vector2D P = evaluateBspline(CUBIC, u);

    //Evaluates the phantom points and adds them to the sum.
    //pStart = (2P0 - P1) * B(nu - i), i = -1
    P += (2 * controlPoints[0] - controlPoints[1]) 
                * evaluateCubicB(n * u - (-1));
    //pEnd = (2Pn - Pn-1) * B(nu - i), i = n + 1
    P += (2 * controlPoints[n] - controlPoints[n - 1]) 
                * evaluateCubicB(n * u - (n + 1));

    return P;
}

/*
* evaluateBspline iterates through the control points and calculates the p 
* value relative to u.
*
* int       mode    specifices the set of the functions that the program 
*                   should use to accoplish the desired operation.
* double    u       a value between [0, 1] that will be used to calculate r
*                   for B.
*/
Vector2D curveOperations::evaluateBspline(int mode, double u) const {
    assert(u >= 0.0f && u <= 1.0f);
    assert(controlPoints.size() > 1);

    //Calls the evaluateClosed and evaluatePhantom to do recusrive operations
    //for code efficiency.
    if (mode == CLOSED) return evaluateClosed(u);
    else if (mode == PHANTOM) return evaluatePhantom(u); 

    int         n       = controlPoints.size() - 1;
    double      B;
    Vector2D    P       = Vector2D(0.0, 0.0);

    //Iterates through the control points and sums the results of the P * B.
    //The switch statement is used to determine the set of functions needed
    //needed to accomplish the desired operation based on the mode value.
    for (int i = 0; i <= n; ++i) {
        switch(mode) {
            case BEZIER:
                B = binomialCoefficient(n, i) 
                    * pow((1 - u), (n - i)) * pow(u, i);
                break;

            case CUBIC:
                B = evaluateCubicB(n * u - i);
                break;

            case BETA:
                B = evaluateBetaB(n * u - i);
                break;

            case BETA_CLOSED:
                B = evaluateBetaB((n + 1) * u - i);
                break;
        }

        P += controlPoints[i] * B;
    }

    return P;
}

/*
* drawBspline draws the desired curve based on the mode.
*
* int       mode    specifices the set of the functions that the program 
*                   should use to accoplish the desired operation.
*/
void curveOperations::drawBspline(int mode) const {
    int         range = 1.0/DELTA_U;
    Vector2D    next,
                prev = evaluateBspline(mode, 0);

    //Iterates through the u values between [0, 1]
    for (int i = 1; i <= range; ++i) {
        next = evaluateBspline(mode, i * DELTA_U);

        drawLine(prev, next);

        prev = next;
    }
}

void curveOperations::drawBezier() const {
    // Draw this Bezier curve.
    // Do this by evaluating the curve at some finite number of t-values,
    // and drawing line segments between those points.
    // You may use the curveOperations::drawLine() function to do the actual
    // drawing of line segments.

    //@@@@@@@@@@
    // YOUR CODE HERE

    drawBspline(BEZIER);

    //@@@@@@@@@@
 
}


void curveOperations::drawControlPolygon() const {
    for (size_t i = 1; i < controlPoints.size(); ++i) {
        drawLine(controlPoints[i-1], controlPoints[i]);
    }
}


unsigned long curveOperations::binomialCoefficient(int n, int k) {
    // Compute nCk ("n choose k")
    // WARNING: Vulnerable to overflow when n is very large!

    assert(k >= 0);
    assert(n >= k);

    unsigned long result = 1;
    for (int i = 1; i <= k; ++i)
    {
        result *= n-(k-i);
        result /= i;
    }
    return result;
}


void curveOperations::drawLine(const Vector2D& p1, const Vector2D& p2) {
    glBegin(GL_LINES);
    glVertex2f(p1[0], p1[1]);
    glVertex2f(p2[0], p2[1]);
    glEnd();
}

// draw cubic bspline
void curveOperations::drawCubicBspline() const {
	//@@@@@@@@@@
    // YOUR CODE HERE
	
    drawBspline(CUBIC);

	//@@@@@@@@@@
}

// draw betaspline
void curveOperations::drawBetaspline() const
{
	//@@@@@@@@@@
    // YOUR CODE HERE

    drawBspline(BETA);

	//@@@@@@@@@@
}

// draw betaspline for closed curve
void curveOperations::drawBetasplineClosedCurve() const
{
	//@@@@@@@@@@
    // YOUR CODE HERE

    drawBspline(CLOSED);

	//@@@@@@@@@@
}

// draw cubic bspline with phantom endpoints
void curveOperations::drawCubicBsplinePhantom() const
{
	//@@@@@@@@@@
    // YOUR CODE HERE

    drawBspline(PHANTOM);

	//@@@@@@@@@@
}



/*************************** You don't need to modify this block ***************************/
void CurveManager::drawCurves() const
{
    if (points == NULL || points->size() < 2)
    {
        return;
    }

    if (curveMode == BEZIER_MODE)
    {
        // Basic Mode (default)
        // Create a Bezier curve from the entire set of points,
        // and then simply draw it to the screen.
        
        curveOperations curve(*points);
        curve.drawBezier();

    }
	else
		if (curveMode == CUBIC_BSPLINE_MODE)
		{
			// mode to draw a cubic b-spline
			curveOperations curve(*points);
			curve.drawCubicBspline();
		}
		else
			if (curveMode == BETA_SPLINE_MODE)
			{
				// mode to draw a beta-spline
				curveOperations curve(*points);
				curve.drawBetaspline();
			}
			else
				if (curveMode == BETA_SPLINE_CLOSEDCURVE_MODE)
				{
					// mode to draw a beta-spline for closed curve
					curveOperations curve(*points);
					curve.drawBetasplineClosedCurve();
				} 
				else
					if (curveMode == CUBIC_BSPLINE_PHANTOM_MODE)
					{
						// mode to draw a cubic b-spline with phantom endpoints
						curveOperations curve(*points);
						curve.drawCubicBsplinePhantom();
					}
}
/*************************** You don't need to modify this block ***************************/


